import 'package:flutter_chart/chart/bar/bar_entry.dart';

/// FileName tick_item
///
/// @Author junhua
/// @Date 2024/4/3
/// 行情数据，逐笔数据
class TickItemEntry extends BarEntry {
  /// 价格
  final double price;

  /// 成交量
  final double volume;

  /// 交易时间
  final int exchangeDataTimeMs;

  /// 上一个交易日的成交价
  final double priceLastClose;

  TickItemEntry(
      {required this.price,
      required this.volume,
      required this.exchangeDataTimeMs,
      required this.priceLastClose,
      super.isBlank})
      : super(
          exchangeDataTimeMs.toDouble(),
          price,
        );
}
