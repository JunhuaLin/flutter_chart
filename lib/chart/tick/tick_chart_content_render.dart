import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/tick/tick_chart_spec.dart';
import 'package:flutter_chart/chart/tick/tick_item_entry.dart';

/// FileName tick_chart_content_render
///
/// @Author junhua
/// @Date 2024/4/3
class TickChartContentRender extends XYChartContentRender<XYComponentCalculator<TickItemEntry>> {
  /// Tick图特性
  final TickChartSpec tickChartSpec;

  /// 绘制折线画笔
  final Paint _tickLinePaint;

  TickChartContentRender(
    super.calculator, {
    required this.tickChartSpec,
    super.level,
  }) : _tickLinePaint = Paint()
          ..strokeWidth = tickChartSpec.lineWidth
          ..color = tickChartSpec.lineColor
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke;

  @override
  void drawContent(
    Canvas canvas,
    XYComponentCalculator<TickItemEntry> calculator,
    double contentWidth,
    double contentHeight,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    Path pricePath = Path();
    calculator.buildLinePath(
      pricePath,
      null,
      startIndex,
      displayCount,
      calculator.entryList,
      (entry, index) => entry.price,
    );
    canvas.drawPath(pricePath, _tickLinePaint);
  }
}
