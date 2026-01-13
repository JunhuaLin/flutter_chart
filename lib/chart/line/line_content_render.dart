import 'dart:math';
import 'dart:ui';

import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/line/line_spec.dart';

/// @Description 绘制折线的render
///
/// @Author junhua
/// @Date 2023/8/7
class LinetContentRender extends XYChartContentRender<XYComponentCalculator> {
  /// 绘制折线的特性
  LineSpec lineSpec;

  /// 绘制折线的画笔
  Paint linePaint;

  /// 绘制折线下的渐变填充画笔
  Paint shaderPaint;

  /// 当只有一个点的时候，绘制的圆的半径
  final double radius;

  LinetContentRender(
    super.calculator, {
    required this.lineSpec,
    super.level,
  })  : linePaint = Paint()
          ..color = lineSpec.lineColor
          ..strokeWidth = lineSpec.lineWidth,
        shaderPaint = Paint(),
        radius = lineSpec.circleRadius;

  @override
  void drawContent(
    Canvas canvas,
    XYComponentCalculator calculator,
    double contentWidth,
    double contentHeight,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    var entryList = calculator.entryList;

    // 绘制的起始点的偏移量
    double startXOffset = 0;
    double startYOffset = 0;

    // 绘制的点的偏移量
    double xOffset = 0;
    double yOffset = 0;

    // 标记当前是否需要绘制点（有效点只有1个构不成线的情况为true）
    bool needDrawPoint = true;
    double endXOffset = xOffset;

    // 绘制的折线轨迹
    Path path = Path();

    // 折线图由于要做成连贯的，因此起始坐标需要-1，结束坐标需要+1
    double startYValue = double.negativeInfinity;
    int realStartIndex = max((startIndex - 1).floor(), 0);
    int endIndex = min((startIndex + displayCount + 1).ceil(), entryList.length);

    // 移动到第一个有效点的位置
    while ((startYValue == double.negativeInfinity || startYValue == double.maxFinite) &&
        realStartIndex < endIndex) {
      startYValue = entryList[realStartIndex].y.toDouble();
      realStartIndex++;
    }

    if (startYValue == double.negativeInfinity || startYValue == double.maxFinite) {
      return;
    }

    startXOffset = calculator.getXOffsetWithItem(realStartIndex - 1);
    startYOffset = calculator.getYOffset(startYValue);

    endXOffset = xOffset;
    path.moveTo(startXOffset, startYOffset);

    for (int index = realStartIndex; index < endIndex; index++) {
      Entry entry = entryList[index];
      if (!entry.isValid) {
        continue;
      }

      double yValue = lineSpec.lineValueProvider?.call(entry) ?? entry.y;
      xOffset = calculator.getXOffsetWithItem(index);
      yOffset = calculator.getYOffset(yValue);
      needDrawPoint = false;
      path.lineTo(xOffset, yOffset);
      endXOffset = xOffset;
    }

    // 只有一个有效点，构不成一条线这种情况下只绘制一个点
    if (needDrawPoint) {
      linePaint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(startXOffset, startYOffset), radius, linePaint);
      return;
    }

    linePaint.style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);

    _drawShader(
      canvas,
      calculator.drawContentHeight,
      path,
      startXOffset,
      startYOffset,
      endXOffset,
    );
  }

  /// 绘制折线下的阴影
  void _drawShader(
    Canvas canvas,
    height,
    Path path,
    double startXOffset,
    double startYOffset,
    double endXOffset,
  ) {
    var shaderColors = lineSpec.shaderColor;
    if (lineSpec.showShader) {
      path.lineTo(endXOffset, height);
      path.lineTo(startXOffset, height);
      path.lineTo(startXOffset, startYOffset);

      // 如果外部设置的shaderColors只有一个颜色，或者设置的两个颜色色值一样
      // 这里为了避免系统绘制出现异常，就不使用Shader了 直接设置Paint颜色
      if (shaderColors.length == 1 ||
          (shaderColors.length > 1 && shaderColors[0] == shaderColors[1])) {
        if (shaderColors[0].value == 0) {
          // 透明色直接return不做绘制
          return;
        }
        shaderPaint.color = shaderColors[0];
      } else {
        shaderPaint.shader = Gradient.linear(
          const Offset(0, 0),
          Offset(0, height),
          lineSpec.shaderColor,
        );
      }

      canvas.drawPath(path, shaderPaint);
    }
  }
}
