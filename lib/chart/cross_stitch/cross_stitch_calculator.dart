import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/core/base_chart_calculator.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_label_pos.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';

/// @Description 十字星的计算器
///
/// @Author junhua
/// @Date 2023/8/8
class CrossStitchCalculator extends BaseChartCalculator {
  /// 绘制轴的上下文方法
  AxisContextCalculator axisContext;

  /// 轴是否限制了超过范围
  bool get yAxisLabelCanExceedAxisLine => axisContext.yAxisLabelCanExceedAxisLine;

  /// 轴是否可以超过范围
  bool get xAxisLabelCanExceedAxisLine => axisContext.xAxisLabelCanExceedAxisLine;

  /// x轴方向上的偏移量
  double get leftOffset => axisContext.axisLeftOffset;

  /// 竖直方向上的偏移量
  double get axisHeight => axisContext.drawContentHeight;

  /// 竖直方向上的偏移量
  double get _axisRightMargin => axisContext.yAxisTextRightMargin;

  /// 水平方向上的偏移
  double get _axisTopMargin => axisContext.xAxisTextTopMargin;

  /// 水平方向上的偏移量
  double get axisWidth => axisContext.drawChartWidth;

  double get xAxisLineWidth => axisContext.xAxisLineWidth;

  double get _yAxisLineWidth => axisContext.yAxisLineWidth;

  double get topOffset => axisContext.topOffset;

  bool get showYLabelInner => axisContext.yAxisLabelInside;

  /// 当光标宽度大于刻度宽度时，加个默认左右边距
  final double _yLabelHorDefaultMargin = 4.px;

  /// y轴文本上下边距
  final double _yAxisLabelVertSpace = 20.px;

  ///  默认的背景圆角
  final double _rectDefaultCircle = 6.px;

  /// 文字内容和边框的左右边距
  final double _xAxisLabelSpace = 12.px;

  CrossStitchCalculator(super.dataSet, this.axisContext);

  /// 获取长按时，最接近的index值
  int getHoldIndex(double posX) {
    return axisContext.getXAxisIndexOfHold(posX);
  }

  /// 根据index获取在dataSet里面的item
  dynamic getHoldData(int index) {
    return dataSet.data[index];
  }

  /// 获取x轴上的文本
  String getXLabelText(int index) {
    return axisContext.getXAxisTextByDataIndex(index);
  }

  /// 计算x上的偏移量
  double getXOffset(int index) {
    return axisContext.getXOffsetByDataIndexWithStartIndex(index) + axisContext.itemWidth / 2;
  }

  /// 根据位置获取在y轴上的文本
  String getYAxisText(double holdPosY) {
    var entryValue = axisContext.getYAxisDataValueByPos(holdPosY);
    return axisContext.getYAxisLabelTextByDataValue(entryValue);
  }

  /// 获取y 轴label 的位置信息
  CrossStitchLabelPos getYAxisLabelPos(
    String text,
    TextStyle style,
    double radius,
    double holdY,
    EdgeInsets textMargin,
    EdgeInsets labelMargin,
  ) {
    double textWidth = axisContext.calculateTextWidth(text, style);
    double textHorMargin = max(textMargin.left, textMargin.right) == 0
        ? _yLabelHorDefaultMargin
        : max(textMargin.left, textMargin.right);
    double textVerMargin = max(textMargin.top, textMargin.bottom) == 0
        ? _yAxisLabelVertSpace
        : max(textMargin.top, textMargin.bottom);

    // 左右增加边距
    double textSpace = (leftOffset >= textWidth) ? (leftOffset - textWidth) / 2 : textHorMargin;
    double labelWidth = textWidth + 2 * textSpace;
    double labelSpace = max(labelMargin.left, labelMargin.right) == 0
        ? _axisRightMargin
        : max(labelMargin.left, labelMargin.right);

    // 上下增加边距
    double textHeight = axisContext.calculateTextHeight(text, style) + textVerMargin;
    double halfTextHeight = textHeight / 2;
    double yTop = holdY - halfTextHeight;
    double yBottom = holdY + halfTextHeight;

    // 需要考虑是否显示为边界内
    double right =
        showYLabelInner ? leftOffset + labelWidth : leftOffset - labelSpace - _yAxisLineWidth;
    double left = right - labelWidth;

    if (!yAxisLabelCanExceedAxisLine) {
      // 限制上下边界显示
      if (yTop < 0) {
        yTop = 0;
        yBottom = textHeight;
      }

      if (yBottom > axisHeight) {
        yTop = axisHeight - textHeight;
        yBottom = axisHeight;
      }
    }

    return CrossStitchLabelPos(
      backGroundTop: yTop,
      backGroundBottom: yBottom,
      backGroundLeft: left,
      backGroundRight: right,
      backGroundRadius: radius == 0 ? _rectDefaultCircle : radius,
      textXPos: left + textSpace,
      textYPos: yTop + textVerMargin / 2,
    );
  }

  /// 获取x 轴label 的位置信息
  CrossStitchLabelPos getXAxisLabelPos(
    String text,
    TextStyle style,
    double radius,
    double xOffset,
    EdgeInsets textMargin,
    EdgeInsets labelMargin,
  ) {
    double textHorMargin = max(textMargin.left, textMargin.right) == 0
        ? _xAxisLabelSpace
        : max(textMargin.left, textMargin.right);
    double textVerMargin = max(textMargin.top, textMargin.bottom);

    double labelVerMargin = _axisTopMargin;

    double textWidth = axisContext.calculateTextWidth(
          text,
          style,
        ) +
        textHorMargin * 2;
    double drawXOffset = xOffset - textWidth / 2;

    double textHeight = axisContext.calculateTextHeight(
          text,
          style,
        ) +
        textVerMargin * 2;

    if (!xAxisLabelCanExceedAxisLine) {
      if (drawXOffset < leftOffset) {
        drawXOffset = leftOffset;
      }

      if (drawXOffset + textWidth > axisWidth) {
        drawXOffset = axisWidth - textWidth;
      }
    }

    double drawYOffset = axisHeight + xAxisLineWidth + labelVerMargin;

    return CrossStitchLabelPos(
      backGroundTop: drawYOffset,
      backGroundBottom: drawYOffset + textHeight,
      backGroundLeft: drawXOffset,
      backGroundRight: drawXOffset + textWidth,
      backGroundRadius: radius == 0 ? _rectDefaultCircle : radius,
      textXPos: drawXOffset + textHorMargin,
      textYPos: drawYOffset + textVerMargin,
    );
  }

  /// 获取y轴上的偏移量
  double getYOffset(int index) {
    return axisContext.getYOffsetByDataIndex(index);
  }

  /// 根据y值 获取y轴上的偏移量
  double getYOffsetByData(double value) {
    return axisContext.getYOffsetByDataValue(value);
  }
}
