import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/provider/axis_value_provider.dart';

/// FileName high_and_low_label_spec
///
/// @Author junhua
/// @Date 2024/4/3
/// @Description 最高点和最低点的特性
class HighAndLowLabelSpec extends Equatable {
  /// 标签样式
  final TextStyle labelTextStyle;

  /// 标签的线的颜色
  final Color lineColor;

  /// 标签的线的宽度
  final double lineWidth;

  /// 用于对标签显示进行变换
  final StringProvider? labelFormatter;

  const HighAndLowLabelSpec({
    this.lineColor = Colors.lightBlue,
    this.lineWidth = 1.0,
    this.labelTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
    this.labelFormatter,
  });

  @override
  List<Object?> get props => [
        lineColor,
        lineWidth,
        labelTextStyle,
      ];
}
