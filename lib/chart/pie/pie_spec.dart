import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// 饼图特性
///
/// @Author theonlin
/// @Date 2023-11-27
class PieSpec extends Equatable {
  const PieSpec({
    required this.innerRadius,
    required this.outerRadius,
    required this.outerExpandRadius,
    this.innerColor,
    this.startDegreeOffset = 0,
    this.sectionSpace = 0,
  }) : assert(innerRadius >= 0 && outerRadius > innerRadius && outerExpandRadius >= outerRadius);

  /// 内圆半径
  final double innerRadius;

  /// 外圆半径
  final double outerRadius;

  /// 外圆点击后的路径
  final double outerExpandRadius;

  /// 内圆颜色
  final Color? innerColor;

  /// 扇形间隔
  final double sectionSpace;

  /// 起始角度，0 点钟方向为 0，顺时针旋转半周为 180
  final double startDegreeOffset;

  /// 扇形颜色列表，超出扇形数量则颜色循环复用
  final List<Color> sectionColors = const [
    Color(0xFF50D8F0),
    Color(0xFF0095FF),
    Color(0xFF0057FF),
    Color(0xFF21BB5E),
    Color(0xFFACD653),
    Color(0xFFFEC710),
    Color(0xFFFF974A),
    Color(0xFFFF7246),
    Color(0xFFAB74FF),
    Color(0xFF7074F5),
  ];

  /// 第 [index] 个扇形颜色
  Color sectionColor(int index) => sectionColors[index % sectionColors.length];

  @override
  List<Object?> get props => [
        innerRadius,
        outerRadius,
        outerExpandRadius,
        innerColor,
        sectionSpace,
        startDegreeOffset,
        sectionColors,
      ];
}
