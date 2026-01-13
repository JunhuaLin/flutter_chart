import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// @Description 折线特性
///
/// @Author junhua
/// @Date 2023/8/2
class LineSpec extends Equatable {
  /// 折线颜色
  final Color lineColor;

  /// 折线宽度
  final double lineWidth;

  /// 只有一个点时需要绘制的圆点的半径PX值，默认3像素，初始化时需要根据CIRCLE_RADIUS_DP的值来换算
  final double circleRadius;

  /// 显示shader
  final bool showShader;

  /// shader颜色
  final List<Color> shaderColor;

  /// 根据entry的值返回y值
  final LineValueProvider? lineValueProvider;

  static const colorList = [Color(0x4D0095FF), Color(0x000095FF)];

  const LineSpec({
    this.lineColor = const Color(0xFF0095FF),
    this.lineWidth = 2,
    this.showShader = true,
    this.shaderColor = colorList,
    this.circleRadius = 3,
    this.lineValueProvider,
  });

  @override
  List<Object?> get props => [
        lineColor,
        lineWidth,
        showShader,
        shaderColor,
        circleRadius,
        lineValueProvider,
      ];
}

typedef LineValueProvider<T> = double Function(T value);
