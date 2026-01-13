import 'package:flutter_chart/flutter_chart.dart';

/// FileName kline_point
///
/// @Author junhua
/// @Date 2024/3/22
class KLinePoint extends CandleEntry {
  /// 开盘价
  double? openPrice;

  /// 收盘价
  double? closePrice;

  /// 盘中最高价
  double? highestPrice;

  /// 盘中最低价
  double? lowestPrice;

  /// 上一个交易日成交价
  double? lastClosePrice;

  KLinePoint({
    this.openPrice,
    this.closePrice,
    this.highestPrice,
    this.lowestPrice,
    this.lastClosePrice,
    double? volume,
    required int tradeTime,
  }) : super(
          openPrice ?? 0,
          closePrice ?? 0,
          highestPrice ?? 0,
          lowestPrice ?? 0,
          volume ?? 0,
          tradeTime,
          isBlank: openPrice == null,
        );
}
