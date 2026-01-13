import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// @Description 轴线特性
///
/// @Author junhua
/// @Date 2023/8/2
class AxisSpec extends Equatable {
  /// 显示网格线
  final bool showGirdLine;

  /// 网格线颜色
  final Color gridLineColor;

  /// 网格线宽度
  final double gridLineWidth;

  /// 是否使用网格线
  final bool gridLineUseDash;

  /// 网格线的虚线宽度
  final double gridLineDashWidth;

  /// 网格线的虚线间隔
  final double gridLineDashSpan;

  /// 显示轴线
  final bool showAxisLine;

  /// 轴线颜色
  final Color axisLineColor;

  /// 轴线宽度
  final double axisLineWidth;

  /// 显示label
  final bool showLabel;

  /// label的间距
  final EdgeInsets labelMargin;

  /// label的style
  final TextStyle labelTextStyle;

  /// 间隔
  final double itemMargin;

  /// 最大的item的间隔，用于计算缩放比例
  final double maxItemMargin;

  /// 最小的item的间隔，用于计算缩放比例
  final double minItemMargin;

  /// item的宽度
  final double itemWidth;

  /// 最大的item的宽度，用于计算缩放比例
  final double maxItemWidth;

  /// 最小的item的宽度，用于计算缩放比例
  final double minItemWidth;

  /// 是否标签画在里面
  final bool drawInner;

  /// 显示顶部的网格线
  final bool drawTopDottedGridLine;

  /// label是否可以超过轴线
  final bool labelCanExceedAxisLine;

  const AxisSpec({
    this.showGirdLine = true,
    this.gridLineColor = Colors.grey,
    this.gridLineWidth = 1,
    this.showAxisLine = true,
    this.axisLineColor = Colors.grey,
    this.axisLineWidth = 1,
    this.showLabel = true,
    this.labelMargin = const EdgeInsets.all(0),
    this.labelTextStyle = const TextStyle(fontSize: 12, color: Colors.black),
    this.itemMargin = 0,
    this.itemWidth = 0,
    this.drawInner = false,
    this.minItemMargin = 0,
    this.maxItemMargin = 0,
    this.maxItemWidth = 20,
    this.minItemWidth = 5,
    this.gridLineUseDash = false,
    this.gridLineDashWidth = 1,
    this.gridLineDashSpan = 3,
    this.drawTopDottedGridLine = true,
    this.labelCanExceedAxisLine = false,
  });

  @override
  List<Object?> get props => [
        showGirdLine,
        gridLineColor,
        gridLineWidth,
        showAxisLine,
        axisLineColor,
        axisLineWidth,
        showLabel,
        labelMargin,
        labelTextStyle,
        itemMargin,
        itemWidth,
        drawInner,
        drawTopDottedGridLine,
        labelCanExceedAxisLine,
      ];
}
