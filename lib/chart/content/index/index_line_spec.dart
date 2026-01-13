import 'package:flutter/material.dart';

/// FileName index_line_spec
///
/// @Author junhua
/// @Date 2024/3/13
/// 指标线的特性设置
class IndexLineSpec {
  /// 线的颜色
  final Color lineColor;

  /// 线的宽度
  final double lineWidth;

  /// 虚线长度,默认为0, 不绘制虚线
  final double dashWidth;

  /// 虚线间隔
  final double dashSpan;

  /// 构造函数
  ///
  /// [lineColor] 线的颜色
  /// [lineWidth] 线的宽度
  /// [lineStyle] 线的样式
  const IndexLineSpec({
    this.lineColor = Colors.orange,
    this.lineWidth = 1,
    this.dashWidth = 0,
    this.dashSpan = 0,
  });
}
