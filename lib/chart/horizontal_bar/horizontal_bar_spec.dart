import 'package:flutter/material.dart';

/// FileName hor_bar_spec
///
/// @Author junhua
/// @Date 2023/11/16
/// 横向柱状图的特性
class HorizontalBarSpec {
  /// 每个bar的宽度
  final double barWidth;

  /// bar的前间距
  final double marginStart;

  /// bar的后间距
  final double marginEnd;

  /// bar距离最高虚线的距离
  final double barMarginTop;

  /// bar的颜色
  final Color barColor;

  /// 显示x轴的label
  final bool showXAxisLabel;

  /// x轴Label的TextStyle
  final TextStyle xAxisLabelStyle;

  /// x轴label的margin
  final EdgeInsets xAxisLabelMargin;

  /// 显示x轴的label
  final bool showXSecondaryAxisLabel;

  /// x轴副label字体样式
  final TextStyle xSecondaryAxisLabelStyle;

  /// x轴副label的margin
  final EdgeInsets xSecondaryAxisLabelMargin;

  /// 网格线宽度
  final double gridLineWidth;

  /// 网格线颜色
  final Color gridLineColor;

  /// 网格虚线的数目
  final int gridLineCount;

  /// 虚线的长度
  final double gridLindDashWidth;

  /// 虚线之间的间隔
  final double gridLineDashSpan;

  /// 是否显示网格线
  final bool showGridLine;

  /// 轴线颜色
  final Color axisLineColor;

  /// 轴线宽度
  final double axisLineWidth;

  const HorizontalBarSpec({
    this.barWidth = 20,
    this.marginStart = 0,
    this.marginEnd = 0,
    this.barMarginTop = 20,
    this.barColor = Colors.blue,
    this.showXAxisLabel = true,
    this.xAxisLabelStyle = const TextStyle(fontSize: 5),
    this.xAxisLabelMargin = const EdgeInsets.only(top: 20),
    this.showXSecondaryAxisLabel = true,
    this.xSecondaryAxisLabelStyle = const TextStyle(fontSize: 5),
    this.xSecondaryAxisLabelMargin = const EdgeInsets.only(top: 20),
    this.gridLineWidth = 2,
    this.gridLineColor = Colors.grey,
    this.gridLineCount = 4,
    this.gridLindDashWidth = 2,
    this.gridLineDashSpan = 2,
    this.showGridLine = true,
    this.axisLineColor = Colors.grey,
    this.axisLineWidth = 2,
  });
}
