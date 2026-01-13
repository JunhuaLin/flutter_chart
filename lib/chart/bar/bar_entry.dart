import 'package:flutter_chart/chart/data/entry.dart';

/// FileName BarEntry
///
/// @Author junhua
/// @Date 2024/3/27
/// @Description 柱状图数据结构
class BarEntry extends Entry<double, double> {
  /// 柱子的最小数据
  double? minValue;

  /// 柱子的最大数据
  double? maxValue;

  BarEntry(
    double x,
    double y, {
    bool isBlank = false,
    this.minValue,
    this.maxValue,
  }) : super(
          x,
          y,
          isBlank: isBlank,
        );

  @override
  String toString() {
    return "BarEntry{x: $x, y: $y, minValue: $minValue, maxValue: $maxValue}";
  }
}
