import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/core/base_chart.dart';

/// @Description chart的基础画笔
///
/// @Author junhua
/// @Date 2023/8/2
class ChartCustomPainter extends CustomPainter {
  ///  图表数据，用于判断是否需要重绘
  final BaseChart chart;

  /// 绘制方法
  Function(Canvas, Size) paintFun;

  ChartCustomPainter(this.chart, this.paintFun);

  /// 绘制
  @override
  void paint(Canvas canvas, Size size) {
    paintFun.call(canvas, size);
  }

  /// 判断是否需要重新绘制
  @override
  bool shouldRepaint(covariant ChartCustomPainter oldDelegate) {
    return chart.shouldRepaint(oldDelegate.chart);
  }
}
