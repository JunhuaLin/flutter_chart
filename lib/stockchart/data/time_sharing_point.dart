import 'dart:core';

import 'package:flutter_chart/chart/time_share/time_sharing_entry.dart';

/// FileName time_sharing_point
///
/// @Author junhua
/// @Date 2024/4/2
class TimeSharingPoint extends TimeSharingEntry {
  /// 开盘价（用于指标计算）
  final double? open;

  ///最高价（用于指标计算）
  final double? high;

  /// 最低价（用于指标计算）
  final double? mLow;

  /// 成交额
  final double? turnover;

  /// 成交量
  final double volume;

  /// 涨跌额
  final double? changeAmount;

  /// 涨跌幅
  final double? changeRatio;

  /// 换手率
  final double? turnoverRate;

  /// 期权隐含波动率对应PB协议里的implied_volatility
  final double? mIV;

  /// 指标函数VOLA使用的参数：港股指数为成交额、其他类型为成交量
  final double? volA;

  /// 上一周期收盘价
  final double? lastClose;

  /// 量比指标数据
  final double? qrrValue;

  /// 成交量是否为空
  final bool hasValidVolume;

  /// 到期收益率
  final double? ytm;

  TimeSharingPoint({
    this.open,
    this.high,
    this.mLow,
    this.turnover,
    this.volume = 0,
    this.changeAmount,
    this.changeRatio,
    this.turnoverRate,
    this.mIV,
    this.volA,
    this.lastClose,
    this.qrrValue,
    this.hasValidVolume = false,
    this.ytm,
    required super.time,
    required super.close,
    required super.average,
    super.isBlank = false,
  });
}
