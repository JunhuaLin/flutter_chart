import 'dart:math' as math;

import 'package:flutter_chart/chart/core/base_chart_calculator.dart';
import 'package:flutter_chart/chart/pie/pie_section.dart';
import 'package:flutter_chart/chart/pie/pie_spec.dart';

/// 饼图计算器
///
/// @Author theonlin
/// @Date 2023-11-27
class PieCalculator extends BaseChartCalculator<PieSection> {
  PieCalculator(
    super.dataSet,
    this.spec, {
    double? currentOuterRadius,
  }) : currentExpandRadius = currentOuterRadius ?? spec.outerExpandRadius;

  /// 饼图规格
  final PieSpec spec;

  /// 当前选中半径（值可随着动画不断更新）
  double currentExpandRadius;

  /// 总和
  late final double sumValue = _calculateSumValue();

  /// 百分比数组
  late final List<double> sectionPercentages = _calculatePercentages();

  /// 角度数组
  late final List<double> sectionDegrees = _calculateDegrees();

  /// 开始弧度数组
  late final List<double> startRadians = _calculateStartRadians();

  /// 角度转弧度
  double radians(double degrees) => degrees / 180.0 * math.pi;

  /// 弧度转角度
  double degrees(double radians) => radians / math.pi * 180.0;

  /// 开始角度（单位：弧度）
  double startRadian(int index) => startRadians[index];

  /// 旋转角度（单位：弧度）
  double sweepRadian(int index) => radians(sectionDegrees[index]);

  /// 结束角度（单位：弧度）
  double endRadian(int index) => startRadian(index) + sweepRadian(index);

  /// 计算所有数据的和
  double _calculateSumValue() {
    if (dataSet.data.isEmpty) return 0;
    return dataSet.data.map((e) => e.value).reduce((a, b) => a + b);
  }

  /// 计算所有数据的百分比
  List<double> _calculatePercentages() {
    if (sumValue == 0) return List.filled(dataSet.data.length, 0.0);
    return dataSet.data.map((section) => section.value / sumValue).toList();
  }

  /// 计算所有扇形的角度
  ///
  /// 1. 尽可能保证每个扇形的最小角度为 1.8°，百分比为 0.5%，避免扇形过小导致不可显示
  /// 2. 创建临时 TempValues 数组，替换过小的数值再重新计算比例，保证所有数据可以有效均分比例
  List<double> _calculateDegrees() {
    final minValue = 1.8 / 360 * sumValue;
    final tempValues = dataSet.data.map((section) => math.max(section.value, minValue)).toList();
    final sumTempValue = tempValues.reduce((a, b) => a + b);
    return tempValues.map((value) => value / sumTempValue * 360).toList();
  }

  /// 计算所有扇形的起始角度（单位：弧度）
  List<double> _calculateStartRadians() {
    var currentAngle = spec.startDegreeOffset;
    final startRadians = <double>[];
    for (var i = 0; i < sectionDegrees.length; i++) {
      // Path 绘制圆弧起始角度是从 3 点钟方向开始，顺时针作为正角绘制，因此起始角度需要 -90°
      final radian = radians(currentAngle - 90);
      startRadians.add(radian);
      currentAngle += sectionDegrees[i];
    }
    return startRadians;
  }
}
