import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/behavior/behavior_callback.dart';
import 'package:flutter_chart/chart/behavior/on_long_press_listener.dart';
import 'package:flutter_chart/chart/behavior/on_tap_listener.dart';
import 'package:flutter_chart/chart/chart_const.dart';
import 'package:flutter_chart/chart/core/base_chart_render.dart';
import 'package:flutter_chart/chart/core/chart.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_calculator.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_label_pos.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_spec.dart';

/// @Description 十字针绘制
///
/// @Author junhua
/// @Date 2023/8/8
class CrossStitchRender extends BaseChartRender<CrossStitchCalculator>
    implements OnLongPressListener, OnTapListener {
  /// 当前长按的x方向的坐标
  double holdPosX;

  /// 当前长按的y方向的坐标
  double holdPosY;

  /// 十字针绘制特性
  CrossStitchSpec crossSpec;

  /// 十字针画笔
  Paint crossLinePaint;

  /// 十字针圆圈画笔
  Paint stitchCirclePaint;

  /// x轴方向label画笔
  TextPainter xLabelPaint;

  /// x轴方向label画笔特性
  TextStyle xLabelTextStyle;

  /// x轴label背景画笔
  Paint xLabelBackgroundPaint;

  /// y轴方向label画笔
  TextPainter yLabelPaint;

  /// y轴方向label画笔特性
  TextStyle yLabelTextStyle;

  /// y轴label背景画笔
  Paint yLabelBackgroundPaint;

  /// 长按的回调
  OnLongPressCallback? longPressCallback;

  /// 十字针延时操作
  Timer? resetPosTimer;

  CrossStitchRender(
    super.calculator, {
    required this.crossSpec,
    super.level,
    this.longPressCallback,
    this.holdPosX = ChartConst.defaultTouchPos,
    this.holdPosY = ChartConst.defaultTouchPos,
  })  : crossLinePaint = Paint()
          ..color = crossSpec.stitchLineColor
          ..strokeWidth = crossSpec.stitchLineWidth,
        stitchCirclePaint = Paint()
          ..color = crossSpec.stitchCircleOuterColor
          ..strokeWidth = crossSpec.stitchCircleLineWidth,
        xLabelTextStyle = crossSpec.labelTextStyle,
        xLabelPaint = TextPainter(textDirection: TextDirection.ltr),
        xLabelBackgroundPaint = Paint()..color = crossSpec.labelBackGroundColor,
        yLabelTextStyle = crossSpec.labelTextStyle,
        yLabelPaint = TextPainter(textDirection: TextDirection.ltr),
        yLabelBackgroundPaint = Paint()..color = crossSpec.labelBackGroundColor;

  @override
  void onInit(IChart chart) {
    super.onInit(chart);
    chart.gestureManager.addOnLongPressListener(this);
    chart.gestureManager.addOnTapListener(this);
  }

  @override
  void onDraw(Canvas canvas, Size size) {
    if (identical(holdPosX, ChartConst.defaultTouchPos) ||
        identical(holdPosY, ChartConst.defaultTouchPos)) {
      return;
    }

    int holdIndex = calculator.getHoldIndex(holdPosX);

    double xOffset = calculator.getXOffset(holdIndex);
    double leftOffset = calculator.leftOffset;
    double width = calculator.axisWidth;
    double height = calculator.axisHeight;
    double xAxisLineWidth = calculator.xAxisLineWidth;
    double topOffset = calculator.topOffset;

    canvas.save();
    canvas.translate(0, topOffset);

    xOffset += leftOffset;

    bool yPosInBound = holdPosY >= 0 && holdPosY <= height;

    // 画十字针的竖线
    _drawCrossLine(
      canvas,
      xOffset,
      xAxisLineWidth,
      height,
      leftOffset,
      width,
      yPosInBound,
    );

    // 是否绘制y轴标签
    _drawXYLabel(
      yPosInBound,
      canvas,
      holdIndex,
      xOffset,
      crossSpec.labelPadding,
      crossSpec.labelMargin,
    );

    // 绘制圆圈
    drawCircle(canvas, holdIndex, xOffset);

    canvas.restore();
  }

  /// 绘制圆圈，子类可继承实现
  void drawCircle(Canvas canvas, int holdIndex, double xOffset) {
    if (crossSpec.showStitchCircle) {
      double circleY = calculator.getYOffset(holdIndex);
      stitchCirclePaint.color = crossSpec.stitchCircleOuterColor;
      // 绘制外圆
      canvas.drawCircle(
        Offset(xOffset, circleY),
        crossSpec.stitchOuterCircle,
        stitchCirclePaint,
      );

      stitchCirclePaint.color = crossSpec.stitchCircleInnerColor;
      // 绘制内圆
      canvas.drawCircle(
        Offset(xOffset, circleY),
        crossSpec.stitchInnerCircle,
        stitchCirclePaint,
      );
    }
  }

  /// 绘制标签页
  void _drawXYLabel(
    bool yPosInBound,
    Canvas canvas,
    int holdIndex,
    double xOffset,
    EdgeInsets labelTextMargin,
    EdgeInsets labelMargin,
  ) {
    // 是否绘制y轴标签
    bool isDrawYLabel = crossSpec.showYLabel && yPosInBound;
    if (isDrawYLabel && crossSpec.showStitchHorLine) {
      // 获取绘制y轴的文本
      String valueStr = calculator.getYAxisText(holdPosY);
      // 获取绘制y轴文本的位置
      var yAxisLabelPos = calculator.getYAxisLabelPos(
        valueStr,
        yLabelTextStyle,
        crossSpec.labelBackgroundRadius,
        holdPosY,
        labelTextMargin,
        labelMargin,
      );

      _drawLabel(
        canvas,
        yAxisLabelPos,
        valueStr,
        yLabelPaint,
        yLabelTextStyle,
        yLabelBackgroundPaint,
      );
    }

    // 是否绘制X轴标签
    bool isDrawXLabel = crossSpec.showXLabel;
    if (isDrawXLabel) {
      // 获取绘制x轴的文本
      String valueStr = calculator.getXLabelText(holdIndex);
      // 获取绘制x轴文本的位置
      var xAxisLabelPos = calculator.getXAxisLabelPos(
        valueStr,
        xLabelTextStyle,
        crossSpec.labelBackgroundRadius,
        xOffset,
        labelTextMargin,
        labelMargin,
      );
      _drawLabel(
        canvas,
        xAxisLabelPos,
        valueStr,
        xLabelPaint,
        xLabelTextStyle,
        xLabelBackgroundPaint,
      );
    }
  }

  /// 根据位置绘制标签文本和背景
  void _drawLabel(
    Canvas canvas,
    CrossStitchLabelPos labelPos,
    String valueStr,
    TextPainter labelPaint,
    TextStyle textStyle,
    Paint backGroundPaint,
  ) {
    canvas.drawRRect(
      RRect.fromLTRBR(
        labelPos.backGroundLeft,
        labelPos.backGroundTop,
        labelPos.backGroundRight,
        labelPos.backGroundBottom,
        Radius.circular(labelPos.backGroundRadius),
      ),
      backGroundPaint,
    );

    labelPaint.text = TextSpan(text: valueStr, style: textStyle);
    labelPaint.layout();
    labelPaint.paint(canvas, Offset(labelPos.textXPos, labelPos.textYPos));
  }

  /// 绘制十字针
  void _drawCrossLine(
    Canvas canvas,
    double xOffset,
    double xAxisLineWidth,
    double height,
    double leftOffset,
    double width,
    bool isYInBound,
  ) {
    // 画十字针的竖线
    if (crossSpec.showStitchVerLine) {
      // 这里参考牛牛的实现，但不起点是xAxisLineWidth
      canvas.drawLine(
        Offset(xOffset, xAxisLineWidth),
        Offset(xOffset, height),
        crossLinePaint,
      );
    }

    // 画十字针的横线
    if (crossSpec.showStitchHorLine && isYInBound) {
      canvas.drawLine(
        Offset(leftOffset, holdPosY),
        Offset(width, holdPosY),
        crossLinePaint,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    xLabelPaint.dispose();
    yLabelPaint.dispose();
    chart.gestureManager.removeOnLongPressListener(this);
    chart.gestureManager.removeOnTapListener(this);
    resetPosTimer?.cancel();
  }

  /// 通知当前有触摸事件发生
  @override
  void onLongPress(Offset touchOffset) {
    touchOffset = convertGlobalToLocal(touchOffset);
    holdPosX = touchOffset.dx;
    holdPosY = touchOffset.dy;
    // 回调接口触摸操作
    int holdIndex = calculator.getHoldIndex(holdPosX);
    longPressCallback?.onLongPress?.call(
      calculator.getHoldData(holdIndex),
      holdIndex,
    );
    update();
  }

  @override
  void onLongPressDown() {
    _restTouchPos();
  }

  /// 通知当前触摸事件结束
  @override
  void onLongPressUp() {
    resetPosTimer?.cancel();
    resetPosTimer = Timer(const Duration(seconds: 3), () {
      _restTouchPos();
    });
  }

  @override
  void onTapDown(Offset localPosition) {
    _restTouchPos();
  }

  /// 重置触摸位置，使十字针消失，并触发长按松开的回调
  void _restTouchPos() {
    resetPosTimer?.cancel();
    if (holdPosX != ChartConst.defaultTouchPos && holdPosY != ChartConst.defaultTouchPos) {
      holdPosX = ChartConst.defaultTouchPos;
      holdPosY = ChartConst.defaultTouchPos;
      update(() {
        longPressCallback?.onLongPressUp?.call();
      });
    }
  }
}
