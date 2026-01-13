import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/common/IValueProvider.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_render.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_entry.dart';

/// FileName time_sharing_cross_stich_render
///
/// @Author junhua
/// @Date 2024/4/1
/// 分时图的十字线绘制
class TimeSharingCrossStitchRender extends CrossStitchRender {
  /// 均线颜色
  final Color avgLineColor;

  /// 是否显示均线
  final bool showAverageLine;

  /// 价格线颜色
  final Color priceLineColor;

  /// 获取price的方法
  final ValueProvider<TimeSharingEntry> priceProvider;

  /// 获取平均价格的方法
  final ValueProvider<TimeSharingEntry> avgPriceProvider;

  TimeSharingCrossStitchRender(
    super.calculator, {
    required this.priceProvider,
    required this.avgPriceProvider,
    required super.crossSpec,
    this.avgLineColor = Colors.blue,
    this.priceLineColor = Colors.red,
    this.showAverageLine = true,
    super.level,
    super.longPressCallback,
    super.holdPosX,
    super.holdPosY,
  });

  @override
  void drawCircle(Canvas canvas, int holdIndex, double xOffset) {
    double yOffset = 0;
    if (showAverageLine) {
      yOffset = calculator
          .getYOffsetByData(avgPriceProvider.call(calculator.getHoldData(holdIndex), holdIndex));
      stitchCirclePaint.color = avgLineColor;
      _paintFillAndStroke(
          Offset(xOffset, yOffset), crossSpec.stitchOuterCircle, stitchCirclePaint, canvas);
    }

    yOffset = calculator
        .getYOffsetByData(priceProvider.call(calculator.getHoldData(holdIndex), holdIndex));
    stitchCirclePaint.color = priceLineColor;
    _paintFillAndStroke(
        Offset(xOffset, yOffset), crossSpec.stitchOuterCircle, stitchCirclePaint, canvas);
  }

  _paintFillAndStroke(Offset offset, double radius, Paint paint, Canvas canvas) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = crossSpec.stitchCircleLineWidth;
    // 绘制外圆
    canvas.drawCircle(
      offset,
      crossSpec.stitchOuterCircle,
      paint,
    );
  }
}
