import 'package:flutter_chart/chart/bar/bar_entry.dart';

/// 分时图数据
///
/// @Author junhua
/// @Date 2024/4/1
class TimeSharingEntry extends BarEntry {
  /// 时间
  int time;

  /// 收盘价
  double close;

  /// 平均价
  double average;

  TimeSharingEntry({
    required this.time,
    required this.close,
    required this.average,
    bool isBlank = false,
  }) : super(
          time.toDouble(),
          close,
          isBlank: isBlank,
        );

  /// 更新分时图价格
  bool update(TimeSharingEntry? entry) {
    if (entry != null && entry.time == time) {
      close = entry.close;
      average = entry.average;
      isBlank = false;
      return true;
    }

    return false;
  }

  @override
  String toString() {
    return 'TimeSharingEntry{x: $x, y: $y time: $time, close: $close, average: $average}';
  }
}
