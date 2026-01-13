import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// FileName time_sharing_spec
///
/// @Author junhua
/// @Date 2024/4/1
/// @Description 分时图特性
class TimeSharingSpec extends Equatable {
  /// 根据给定的价格与收盘价返回绘制的颜色
  final UpAndDownColorFormatter? colorFormatter;

  /// 是否显示现价线
  final bool showNowPriceLine;

  /// 是否显示均线
  final bool showAverageLine;

  /// 是否显示昨日收价线
  final bool showClosePriceLine;

  /// 价格线的宽度
  final double priceLineStrokeWidth;

  /// 价格线颜色
  final Color priceLineColor;

  /// 平均线的宽度
  final double avgLineStrokeWidth;

  /// 平均线颜色
  final Color avgLineColor;

  /// 收盘线的宽度
  final double closeLineStrokeWidth;

  /// 收盘线颜色
  final Color closeLineColor;

  /// 收盘线的间隔宽度
  final double closeLineDashWidth;

  /// 收盘线的间隔间距
  final double closeLineDashSpan;

  /// 推送点大小
  final double pushPointRadius;

  /// 十字针大小
  final double crossStitchRadius;

  /// shader颜色
  final List<Color> priceShaderColor;

  const TimeSharingSpec(
      {this.colorFormatter,
      this.showNowPriceLine = true,
      this.showAverageLine = true,
      this.showClosePriceLine = true,
      this.priceLineStrokeWidth = 0.5,
      this.priceLineColor = Colors.blue,
      this.avgLineStrokeWidth = 0.5,
      this.avgLineColor = Colors.yellow,
      this.closeLineStrokeWidth = 0.5,
      this.closeLineColor = Colors.white,
      this.pushPointRadius = 3.0,
      this.crossStitchRadius = 6.0,
      this.priceShaderColor = const [Color(0x4D0095FF), Color(0x000095FF)],
      this.closeLineDashSpan = 4.0,
      this.closeLineDashWidth = 10.0});

  @override
  List<Object?> get props => [
        showNowPriceLine,
        showAverageLine,
        showClosePriceLine,
        priceLineStrokeWidth,
        priceLineColor,
        avgLineStrokeWidth,
        avgLineColor,
        closeLineStrokeWidth,
        closeLineColor,
        pushPointRadius,
        crossStitchRadius,
        priceShaderColor,
        closeLineDashSpan,
        closeLineDashWidth
      ];
}

typedef UpAndDownColorFormatter = Color Function(double price, double comparePrice);
