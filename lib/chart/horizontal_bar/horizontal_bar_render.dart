import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/common/dash_painter.dart';
import 'package:flutter_chart/chart/core/base_chart_render.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/horizontal_bar/horizontal_bar_calculator.dart';
import 'package:flutter_chart/chart/horizontal_bar/horizontal_bar_spec.dart';

/// @Description 柱状图的render
///
/// @Author junhua
/// @Date 2023/8/16
class HorizontalBarRender extends BaseChartRender<HorizontalBarCalculator> {
  /// 绘制折线的特性
  HorizontalBarSpec barSpec;

  /// 绘制柱状图的画笔
  final Paint _barPaint;

  /// 绘制轴线的画笔
  final Paint _axisLinePaint;

  /// 绘制网格线的画笔
  final Paint _gridLinePaint;

  /// 绘制轴线label的画笔
  final TextPainter _axisTextPaint;

  /// 绘制副轴线label的画笔
  final TextPainter _secondaryAxisTextPaint;

  /// 虚线绘制
  final DashPainter _dashPainter;

  HorizontalBarRender(super.calculator, {required this.barSpec})
      : _barPaint = Paint()
          ..strokeWidth = barSpec.barWidth
          ..style = PaintingStyle.fill
          ..color = barSpec.barColor,
        _axisLinePaint = Paint()
          ..strokeWidth = barSpec.axisLineWidth
          ..style = PaintingStyle.stroke
          ..color = barSpec.axisLineColor,
        _gridLinePaint = Paint()
          ..strokeWidth = barSpec.gridLineWidth
          ..style = PaintingStyle.stroke
          ..color = barSpec.gridLineColor,
        _axisTextPaint = TextPainter(
          textDirection: TextDirection.ltr,
        ),
        _secondaryAxisTextPaint = TextPainter(
          textDirection: TextDirection.ltr,
        ),
        _dashPainter = DashPainter(
          dashWidth: barSpec.gridLindDashWidth,
          dashSpan: barSpec.gridLineDashSpan,
        );

  @override
  void onDraw(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(calculator.barLeftMargin, 0);

    // 绘制轴线
    _drawAxisAndGridLine(canvas);

    List<Entry<num, num>> barEntryList = calculator.barDataList;
    for (int i = 0; i < barEntryList.length; i++) {
      var entry = barEntryList[i];

      if (!entry.isValid) {
        continue;
      }

      // 绘制柱状图
      _drawBar(i, canvas);

      // 绘制x轴label
      _drawAxisLabel(i, canvas, entry);

      // 绘制副x轴label
      _drawSecondaryAxisLabel(i, canvas, entry);
    }

    canvas.restore();
  }

  /// 绘制矩形
  void _drawBar(int i, Canvas canvas) {
    Rect rect = calculator.getDrawBarRect(i);
    canvas.drawRect(rect, _barPaint);
  }

  /// 绘制x轴label
  void _drawAxisLabel(int i, Canvas canvas, Entry<num, num> item) {
    if (!barSpec.showXAxisLabel) {
      return;
    }

    String labelStr = calculator.getAxisLabelString(i);

    _axisTextPaint
      ..text = TextSpan(
        text: labelStr,
        style: barSpec.xAxisLabelStyle,
      )
      ..layout();

    _axisTextPaint.paint(canvas, calculator.getAxisLabelOffset(i));
  }

  /// 绘制副x轴label
  void _drawSecondaryAxisLabel(int i, Canvas canvas, Entry<num, num> item) {
    if (!barSpec.showXSecondaryAxisLabel) {
      return;
    }

    String label = calculator.getSecondaryAxisLabelString(i);

    _secondaryAxisTextPaint
      ..text = TextSpan(
        text: label,
        style: barSpec.xSecondaryAxisLabelStyle,
      )
      ..layout();

    _secondaryAxisTextPaint.paint(canvas, calculator.getSecondaryAxisLabelOffset(i));
  }

  /// 绘制轴线和网格线
  void _drawAxisAndGridLine(Canvas canvas) {
    // 绘制轴线
    (Offset, Offset) axisLineStartOffset = calculator.getAxisLineStartOffset();
    canvas.drawLine(axisLineStartOffset.$1, axisLineStartOffset.$2, _axisLinePaint);

    // 绘制网格线
    if (barSpec.showGridLine) {
      Path path = Path();
      List<Offset> gridLineStartOffset = calculator.getGridLineStartOffset();
      for (int i = 0; i < gridLineStartOffset.length; i++) {
        var lineStartOffset = gridLineStartOffset[i];
        path.reset();
        path
          ..moveTo(lineStartOffset.dx, lineStartOffset.dy)
          ..lineTo(lineStartOffset.dx + calculator.barWidth, lineStartOffset.dy);

        _dashPainter.draw(canvas, path, _gridLinePaint);
      }
    }
  }
}
