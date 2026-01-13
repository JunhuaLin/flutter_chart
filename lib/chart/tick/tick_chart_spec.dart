import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// FileName tick_chart_spec
///
/// @Author junhua
/// @Date 2024/4/3
/// @Description 逐笔图表配置
class TickChartSpec extends Equatable {
  /// 折线颜色
  final Color lineColor;

  /// 折线宽度
  final double lineWidth;

  const TickChartSpec({
    this.lineColor = Colors.lightBlue,
    this.lineWidth = 1.0,
  });

  @override
  List<Object?> get props => [
        lineColor,
        lineWidth,
      ];
}
