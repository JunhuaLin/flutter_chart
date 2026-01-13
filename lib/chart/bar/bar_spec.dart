import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bar/bar_data_provider.dart';
import 'package:flutter_chart/chart/spec/common_spec.dart';

/// Description: 柱状图特性
///
/// Author: jingweixie
/// Date: 2023-08-15 15:44:27
class BarSpec extends Equatable {
  /// 柱形图的宽度
  final double lineWidth;

  /// 上方bar的颜色
  final Color barColor;

  /// 下方的bar颜色
  final ColorProvider? colorProvider;

  /// 柱状图数据处理
  final IBarDataProvider barDataProvider;

  /// 是否使用短划线
  final bool useDashLine;

  /// 标签颜色
  final Color labelColor;

  /// 标签文字大小
  final double labelTextSize;

  const BarSpec({
    this.lineWidth = 0.5,
    this.barColor = const Color(0xFFED3939),
    this.useDashLine = true,
    this.labelColor = Colors.black,
    this.labelTextSize = 20,
    this.colorProvider,
    this.barDataProvider = const DefaultBarDataProvider(),
  });

  @override
  List<Object?> get props => [
        lineWidth,
        barColor,
        useDashLine,
        labelColor,
        labelTextSize,
        // 不使用colorProvider，因为colorProvider是一个方法，无法比较
        // colorProvider,
      ];
}
