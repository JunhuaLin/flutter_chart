import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/spec/common_spec.dart';

/// FileName push_point_spec
///
/// @Author junhua
/// @Date 2024/3/14
/// @Description 推送点动画显示特性
class PushPointSpec {
  /// 推送点的半径
  final double radius;

  /// 推送点的动画时长,默认1500ms
  final Duration duration;

  /// 绘制推送点的颜色提供器，优先使用颜色提供器的颜色
  final ColorProvider? colorProvider;

  /// 绘制推送点的颜色
  final Color color;

  /// 绘制线的宽度
  final double strokeWidth;

  const PushPointSpec({
    this.radius = 3.0,
    this.colorProvider,
    this.color = Colors.blue,
    this.strokeWidth = 1.0,
    this.duration = const Duration(milliseconds: 2000),
  });
}
