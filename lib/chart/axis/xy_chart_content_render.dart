import 'dart:ui';

import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/core/base_chart_render.dart';

/// @Description x,y轴中内容render
///
/// @Author junhua
/// @Date 2024/4/9
/// 绘制接口
/// [canvas] 绘制的画布
/// [calculator] 计算器，用于获取常用的计算方法
/// [width] 绘制内容的宽度
/// [height] 绘制内容的高度
/// [startIndex] 开始绘制的索引,double类型，平移和缩放过程中会有小数
/// [displayCount] 显示的个数
/// [itemWidth] 每个item的宽度
/// [itemMargin] item之间的间距
/// [begin] 开始的索引，开始绘制的索引，等于[startIndex.toInt()]
/// [end] 结束的索引，结束绘制的索引,等于[startIndex.toInt()+displayCount + 1]
abstract class XYChartContent<T extends XYComponentCalculator> {
  void drawContent(
    Canvas canvas,
    T calculator,
    double width,
    double height,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  );
}

/// xy中内容的render，子类通过继承[drawContent]方法进行绘制
class XYChartContentRender<T extends XYComponentCalculator> extends BaseChartRender<T>
    implements XYChartContent<T> {
  XYChartContentRender(
    super.calculator, {
    super.level,
  });

  /// 将绘制canvas移动到内容区域（坐标轴内区域）
  @override
  void onDraw(Canvas canvas, Size size) {
    canvas.save();
    // 平移到绘制区域，并进行裁剪
    canvas.translate(calculator.leftOffset, calculator.topOffset);
    canvas.clipRect(Rect.fromLTWH(0, 0, calculator.drawContentWidth, calculator.drawContentHeight));
    drawContent(
      canvas,
      calculator,
      calculator.drawContentWidth,
      calculator.drawContentHeight,
      calculator.startIndex,
      calculator.displayCount,
      calculator.itemWidth,
      calculator.itemMargin,
      calculator.begin,
      calculator.end,
    );
    canvas.restore();
  }

  /// 子类实现，绘制内容区域
  /// [contentWidth] 绘制内容的宽度
  /// [contentHeight] 绘制内容的高度
  /// [startIndex] 开始绘制的索引,double类型，平移和缩放过程中会有小数
  /// [displayCount] 显示的个数
  /// [itemWidth] 每个item的宽度
  /// [itemMargin] item之间的间距
  /// [begin] 开始的索引，开始绘制的索引，等于[startIndex.toInt()]
  /// [end] 结束的索引，结束绘制的索引,等于[startIndex.toInt()+displayCount + 1]
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
  ) {}
}

/// XYChartContent容器，提供给外部render进行绘制
class XYChartContentRenderContainer<T extends XYComponentCalculator>
    extends XYChartContentRender<T> {
  List<XYChartContent<T>>? contents;

  XYChartContentRenderContainer(
    super.calculator, {
    super.level,
    this.contents,
  });

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
    if (contents == null || contents!.isEmpty) {
      return;
    }
    for (var content in contents!) {
      content.drawContent(
        canvas,
        calculator,
        contentWidth,
        contentHeight,
        startIndex,
        displayCount,
        itemWidth,
        itemMargin,
        begin,
        end,
      );
    }
  }
}
