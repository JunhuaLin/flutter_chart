import 'package:flutter_chart/chart/bar/bar_entry.dart';

/// FileName candle_entry
///
/// @Author junhua
/// @Date 2024/3/11
/// 蜡烛图的基本数据结构
class CandleEntry extends BarEntry {
  /// 开盘价
  final double open;

  /// 收盘价
  final double close;

  /// 最高价
  final double high;

  /// 最低价
  final double low;

  /// 成交量
  final double volume;

  /// 时间
  final int time;

  /// 蜡烛图矩形顶部的值
  double get candleMaxValue => (open > close) ? open : close;

  /// 蜡烛图矩形底部的值
  double get candleMinValue => (open < close) ? open : close;

  CandleEntry(this.open, this.close, this.high, this.low, this.volume, this.time,
      {bool isBlank = false})
      : super(
          time.toDouble(),
          close,
          isBlank: isBlank,
        );

  @override
  String toString() {
    return 'CandleEntry{open: $open, close: $close, high: $high, low: $low, volume: $volume, time: $time}';
  }
}
