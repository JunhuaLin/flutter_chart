import 'package:flutter_chart/chart/bar/bar_chart_data.dart';
import 'package:flutter_chart/chart/candle/candle_entry.dart';

/// FileName candle_stick_chart_data
///
/// @Author junhua
/// @Date 2024/3/11
class CandleStickChartData<T extends CandleEntry> extends BarChartData<T> {
  ICandleValueProvider? candleValueProvider;

  CandleStickChartData(super.data, {this.candleValueProvider}) {
    candleValueProvider = candleValueProvider ?? DefaultCandleValueProvider();
  }

  /// 根据蜡烛图上下边界进行计算
  @override
  void calculateMinMaxY(T entry) {
    if (entry.low < minY) {
      minY = entry.low;
    }

    if (entry.high > maxY) {
      maxY = entry.high;
    }
  }
}

abstract class ICandleValueProvider<TEntry> {
  ///获取蜡烛图上影线的值
  double getHighValue(TEntry entry);

  /// 获取蜡烛图下影线的值
  double getLowValue(TEntry entry);

  /// 获取蜡烛图矩形顶部的值
  double getTopValue(TEntry entry);

  /// 获取蜡烛图矩形底部的值
  double getBottomValue(TEntry entry);
}

class DefaultCandleValueProvider<TEntry extends CandleEntry> extends ICandleValueProvider<TEntry> {
  @override
  double getHighValue(TEntry entry) => entry.high;

  @override
  double getLowValue(TEntry entry) => entry.low;

  @override
  double getBottomValue(TEntry entry) => entry.candleMinValue;

  @override
  double getTopValue(TEntry entry) => entry.candleMaxValue;
}
