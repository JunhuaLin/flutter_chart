import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/common/dash_painter.dart';
import 'package:flutter_chart/chart/core/base_chart_render.dart';

/// @Description 负责绘制轴的render
///
/// @Author junhua
/// @Date 2023/8/2
abstract class AxisRender extends BaseChartRender<AxisContextCalculator> {
  /// x,y轴特性
  AxisSpec axisSpec;

  /// 绘制网格画笔
  Paint gridLinePaint;

  /// 绘制轴线画笔
  Paint axisLinePaint;

  /// 绘制轴线画笔
  TextPainter textPainter;

  /// 绘制虚线的间隔
  DashPainter dashPainter;

  /// 绘制轴线的文字样式
  TextStyle textStyle;

  /// 轴的坐标数据
  List<double> get axisValueEntries;

  /// 轴的index的坐标数据
  List<int> get indexEntries;

  AxisRender(super.calculator, {required this.axisSpec, super.level})
      : gridLinePaint = Paint()
          ..color = axisSpec.gridLineColor
          ..strokeWidth = axisSpec.gridLineWidth
          ..style = PaintingStyle.stroke,
        axisLinePaint = Paint()
          ..color = axisSpec.axisLineColor
          ..strokeWidth = axisSpec.axisLineWidth,
        textPainter = TextPainter(
          textDirection: TextDirection.ltr,
        ),
        dashPainter = DashPainter(
          dashWidth: axisSpec.gridLineDashWidth,
          dashSpan: axisSpec.gridLineDashSpan,
        ),
        textStyle = axisSpec.labelTextStyle;

  @override
  void onDraw(Canvas canvas, Size size) {
    var topOffset = calculator.topOffset;
    var axisHeight = calculator.drawContentHeight;
    var axisWidth = calculator.drawChartWidth;
    var leftAxisOffset = calculator.axisLeftOffset;
    var xLineWidth = calculator.xAxisLineWidth;
    var yLineWidth = calculator.yAxisLineWidth;

    canvas.save();
    canvas.translate(0, topOffset);

    if (axisSpec.showAxisLine) {
      drawAxisLine(
        canvas,
        axisWidth,
        axisHeight,
        leftAxisOffset,
        xLineWidth,
        yLineWidth,
      );
    }

    if (axisSpec.showGirdLine || axisSpec.showLabel) {
      drawGridAndAxisLabel(
        canvas,
        axisWidth,
        axisHeight,
        leftAxisOffset,
        xLineWidth,
        yLineWidth,
        axisValueEntries,
        indexEntries,
        axisSpec.labelMargin,
      );
    }

    canvas.restore();
  }

  @override
  void dispose() {
    super.dispose();
    textPainter.dispose();
  }

  /// 绘制轴线
  void drawAxisLine(
    Canvas canvas,
    double width,
    double height,
    double leftOffset,
    double xLineWidth,
    double yLineWidth,
  );

  /// 绘制网格线和轴标签线
  void drawGridAndAxisLabel(
    Canvas canvas,
    double width,
    double height,
    double leftOffset,
    double xLineWidth,
    double yLineWidth,
    List<double> axisValueEntries,
    List<int> indexEntries,
    EdgeInsets margin,
  );
}
