import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_render.dart';
import 'package:flutter_chart/chart/common/dash_painter.dart';

/// @Description y轴render
///
/// @Author junhua
/// @Date 2023/8/3
class YAxisRender extends AxisRender {
  @override
  List<double> get axisValueEntries => calculator.yAxisEntries;

  @override
  List<int> get indexEntries => calculator.yAxisIndexEntries;

  YAxisRender(super.calculator, {required super.axisSpec, super.level});

  @override
  void drawAxisLine(
    Canvas canvas,
    double width,
    double height,
    double leftOffset,
    double xLineWidth,
    double yLineWidth,
  ) {
    double halfYLineWidth = yLineWidth / 2;
    canvas.drawLine(
      Offset(
        leftOffset - halfYLineWidth,
        0,
      ),
      Offset(
        leftOffset - halfYLineWidth,
        height + xLineWidth,
      ),
      axisLinePaint,
    );
  }

  @override
  void drawGridAndAxisLabel(
    Canvas canvas,
    double width,
    double height,
    double leftOffset,
    double xLineWidth,
    double yLineWidth,
    List<double> entries,
    List<int> indexEntries,
    EdgeInsets margin,
  ) {
    int size = entries.length;
    double yOffset = 0;
    bool drawGridLine = axisSpec.showGirdLine;
    bool drawLabel = axisSpec.showLabel;
    bool drawTopGridLine = axisSpec.drawTopDottedGridLine;
    double textLeftOffset = leftOffset;
    // if draw axis chart.line 如果绘制网格线
    if (axisSpec.showAxisLine) {
      textLeftOffset -= yLineWidth;
    }

    /// axis的index的集合
    List<double> axisEntrySet = axisValueEntries;
    if (axisEntrySet.isEmpty) {
      axisEntrySet = indexEntries.map((index) => calculator.axisDataSet.data[index].y).toList();
    }

    // 网格线路径
    Path? gridLinePath = Path();
    for (int index = 0; index < axisEntrySet.length; index++) {
      yOffset = calculator.getYOffsetByDataValue(axisEntrySet[index]);
      // 当index0时，不绘制，index为size -1时，不绘制顶部虚线
      if (drawGridLine && index > 0 && (index < (drawTopGridLine ? size : size - 1))) {
        gridLinePath.reset();
        gridLinePath.moveTo(leftOffset, yOffset);
        gridLinePath.lineTo(width, yOffset);
        if (axisSpec.gridLineUseDash) {
          dashPainter.draw(canvas, gridLinePath, gridLinePaint);
        } else {
          canvas.drawPath(gridLinePath, gridLinePaint);
        }
      }
      if (drawLabel) {
        String text = calculator.getYAxisLabelTextByAxisEntryIndex(index);
        Offset textOffset = calculator.getYAxisTextOffset(
          text,
          textStyle,
          textLeftOffset,
          yOffset,
          margin,
        );
        textPainter
          ..text = TextSpan(text: text, style: textStyle)
          ..layout();
        textPainter.paint(canvas, textOffset);
      }
    }
  }
}
