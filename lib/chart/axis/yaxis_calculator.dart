import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter_chart/chart/axis/axis_calculator.dart';

/// @Description y轴的计算器，主要为坐标值和显示的文本
///
/// @Author junhua
/// @Date 2023/8/2
class YAxisCalculator extends AxisCalculator {
  /// 轴方向的最小值
  double get minValue => axisEntrySet.isNotEmpty ? axisEntrySet[0] : 0;

  /// 轴方向的最大值
  double get maxValue => axisEntrySet.isNotEmpty ? axisEntrySet[axisEntrySet.length - 1] : 0;

  @override
  double get dataMax => axisDataSet.maxY;

  @override
  double get dataMin => axisDataSet.minY;

  double get axisTextRightMargin => axisSpec.labelMargin.right;

  YAxisCalculator(
    super.axisDataSet,
    super.axisContext, {
    required super.axisSpec,
    required super.axisValueProvider,
    required super.axisIndexProvider,
  });

  /// 获取y轴标签的最长的宽度
  double _getLeftLabelOffset() {
    double maxOffset = 0;
    double textWidth = 0;
    if (!axisSpec.showLabel) return 0;
    if (axisEntrySet.isEmpty) return 0;
    for (int index = 0; index < axisEntrySet.length; index++) {
      textWidth = getTextWidth(getTextByAxisEntryIndex(index), labelTextStyle);
      maxOffset = max(textWidth, maxOffset);
    }

    return maxOffset + axisSpec.labelMargin.left + axisSpec.labelMargin.right;
  }

  /// 根据value的值，计算在轴上的偏移量
  double _calAxisOffset(num entryValue) {
    double ratio = axisLength / (maxValue - minValue);
    return axisLength - ratio * (entryValue - minValue);
  }

  /// 获取坐标轴左侧的偏移量
  /// [originalOffset] 默认的左边的偏移量
  double getAxisLeftOffset() {
    double offsetLabel = axisSpec.drawInner ? 0 : _getLeftLabelOffset();
    double offsetLine = axisSpec.showAxisLine ? axisSpec.axisLineWidth : 0;
    return offsetLabel + offsetLine;
  }

  /// 计算entry值在轴方向的偏移量
  @override
  double calAxisOffset(_, num entryValue) {
    /// 对于所有值相等的情况，直接显示在表格最下方，适合查看，
    if (maxValue == minValue) return axisLength;
    return _calAxisOffset(entryValue);
  }

  /// 根据位置信息，获取在轴上的值
  double getDataValueByPos(double pos) {
    return ((axisLength - pos) / axisLength) * (maxValue - minValue) + minValue;
  }

  /// 获取距离图表上方的间距
  double getTopOffset() {
    double offset = 0;
    if (axisSpec.showLabel && axisSpec.drawInner == false) {
      offset = getTextHeight(getTextByAxisEntryIndex(0), labelTextStyle) / 2;
    }

    return offset;
  }

  @override
  Offset getTextOffset(
    String text,
    TextStyle style,
    double drawAxisWidth,
    double drawAxisHeight,
    double startX,
    double xOffset,
    double yOffset,
    EdgeInsets textMargin,
  ) {
    if (text.isEmpty) return const Offset(0, 0);

    var textWidth = axisSpec.drawInner
        ? textMargin.left + axisSpec.axisLineWidth
        : (getTextWidth(text, style) + textMargin.right + textMargin.left);
    var textHeight = getTextHeight(text, style);
    var drawXOffset = axisSpec.drawInner ? xOffset + textWidth : xOffset - textWidth;
    // 文字和轴线居中显示
    var drawYOffset = yOffset - textHeight / 2;

    // 上下边界的限制
    if (!labelCanExceedAxisLine) {
      if (drawYOffset < 0) {
        drawYOffset = 0;
      } else if (drawYOffset + textHeight > drawAxisHeight) {
        drawYOffset = drawAxisHeight - textHeight;
      }
    }

    return Offset(drawXOffset, drawYOffset);
  }

  @override
  List<double> indexToValue(List<int> indexList) {
    return indexList.map((index) => axisDataSet.data[index].y).toList();
  }
}
