import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/content/high_low_label/high_and_low_calculator.dart';
import 'package:flutter_chart/chart/content/high_low_label/high_and_low_label_spec.dart';

/// FileName HighAndLowLabelRender
///
/// @Author junhua
/// @Date 2024/4/3
/// @Description 最高最低点的标签绘制
class HighAndLowLabelContentRender<T extends HighAndLowCalculator> extends XYChartContentRender<T> {
  /// 标签特性
  HighAndLowLabelSpec highAndLowLabelSpec;

  /// 绘制label轴线
  final Paint _labelLinePaint;

  /// 绘制标签
  final TextPainter _textPainter;

  HighAndLowLabelContentRender(super.calculator, {required this.highAndLowLabelSpec})
      : _labelLinePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = highAndLowLabelSpec.lineColor
          ..strokeWidth = highAndLowLabelSpec.lineWidth
          ..isAntiAlias = true,
        _textPainter = TextPainter(
          textDirection: TextDirection.ltr,
        );

  @override
  void drawContent(
    Canvas canvas,
    T calculator,
    double contentWidth,
    double contentHeight,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    var minAndMaxIndex = calculator.getMinAndMaxIndex(begin, end);
    final minIndex = minAndMaxIndex.item1;
    final maxIndex = minAndMaxIndex.item2;
    _drawLabel(
      calculator,
      canvas,
      calculator.getXOffsetWithItem(minIndex),
      calculator.getYOffsetWithIndex(minIndex),
      calculator.getYTextWithIndex(minIndex),
      false,
    );
    _drawLabel(
      calculator,
      canvas,
      calculator.getXOffsetWithItem(maxIndex),
      calculator.getYOffsetWithIndex(maxIndex),
      calculator.getYTextWithIndex(maxIndex),
      true,
    );
  }

  /// 绘制最低最高标签
  void _drawLabel(
    T calculator,
    Canvas canvas,
    double x,
    double y,
    String text,
    bool isMaxLabel,
  ) {
    if (text.isEmpty) return;

    // 画线
    var labelOffset =
        calculator.getLabelOffset(text, highAndLowLabelSpec.labelTextStyle, x, y, isMaxLabel);
    Offset labelLineOffset = labelOffset.item1;
    double textYOffset = labelOffset.item2;
    double textWidth = labelOffset.item3;
    canvas.drawLine(Offset(x, y), labelLineOffset, _labelLinePaint);

    // 绘制文本
    _textPainter
      ..textAlign = labelLineOffset.dx < x ? TextAlign.right : TextAlign.left
      ..text = TextSpan(
        text: text,
        style: highAndLowLabelSpec.labelTextStyle,
      )
      ..layout();
    _textPainter.paint(
        canvas,
        Offset(labelLineOffset.dx > x ? labelLineOffset.dx : labelLineOffset.dx - textWidth,
            textYOffset));
  }
}
