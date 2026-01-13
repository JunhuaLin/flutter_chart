import 'dart:ui';

import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/common/dash_painter.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_calculator.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_spec.dart';

/// FileName time_sharing_content_render
///
/// @Author junhua
/// @Date 2024/4/1
class TimeSharingContentRender extends XYChartContentRender<TimeSharingCalculator> {
  ///分时图特性设置
  final TimeSharingSpec spec;

  /// 价格线的画笔
  final Paint _priceLinePaint;

  /// 价格线shader的画笔
  final Paint _priceShaderPaint;

  /// 平均线的画笔
  final Paint _avgLinePaint;

  /// 收盘价的Dash Painter
  final DashPainter _closeDashPainter;

  /// 收盘价的画笔
  final Paint _closeLinePaint;

  /// 收盘的路径
  final Path _closePath = Path();

  TimeSharingContentRender(
    super.calculator, {
    this.spec = const TimeSharingSpec(),
    super.level,
  })  : _priceLinePaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = spec.priceLineColor
          ..strokeWidth = spec.priceLineStrokeWidth,
        _priceShaderPaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill,
        _avgLinePaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = spec.avgLineColor
          ..strokeWidth = spec.avgLineStrokeWidth,
        _closeLinePaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = spec.closeLineColor
          ..strokeWidth = spec.closeLineStrokeWidth,
        _closeDashPainter = DashPainter(
          dashWidth: spec.closeLineDashWidth,
          dashSpan: spec.closeLineDashSpan,
        );

  @override
  void drawContent(
    Canvas canvas,
    TimeSharingCalculator calculator,
    double contentWidth,
    double contentHeight,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    // 绘制收价线
    if (spec.showClosePriceLine && calculator.lastClosePrice > 0) {
      _closePath.reset();
      var lastClosePriceYPos = calculator.getLastClosePriceYPos();
      _closePath.moveTo(0, lastClosePriceYPos);
      _closePath.lineTo(contentWidth, lastClosePriceYPos);
      _closeDashPainter.draw(canvas, _closePath, _closeLinePaint);
    }

    // 绘制内容
    var selections = calculator.selections;
    var drawPath = calculator.getDrawPath(startIndex, displayCount);
    for (int i = 0; i < selections.length; i++) {
      if (selections[i].hasValidEntry && selections[i].entries.isNotEmpty) {
        _drawTimeShareGraph(
            canvas, drawPath.item1[i], drawPath.item2[i], drawPath.item3[i], contentHeight);
      }
    }
  }

  /// 绘制分时图，图案
  void _drawTimeShareGraph(
      Canvas canvas, Path pricePath, Path shaderPath, Path avgPath, double height) {
    // 绘制价格线
    canvas.drawPath(pricePath, _priceLinePaint);

    // 绘制价格线下方的阴影
    // 如果外部设置的shaderColors只有一个颜色，或者设置的两个颜色色值一样
    // 这里为了避免系统绘制出现异常，就不使用Shader了 直接设置Paint颜色
    if (spec.priceShaderColor.length == 1 ||
        (spec.priceShaderColor.length > 1 &&
            spec.priceShaderColor[0] == spec.priceShaderColor[1])) {
      _priceShaderPaint.color = spec.priceShaderColor[0];
      canvas.drawPath(shaderPath, _priceShaderPaint);
    } else {
      // 渐变色处理
      _priceShaderPaint.shader = Gradient.linear(
        const Offset(0, 0),
        Offset(0, height),
        spec.priceShaderColor,
      );
      canvas.drawPath(shaderPath, _priceShaderPaint);
    }

    // 绘制均价线
    if (spec.showAverageLine) {
      canvas.drawPath(avgPath, _avgLinePaint);
    }
  }
}
