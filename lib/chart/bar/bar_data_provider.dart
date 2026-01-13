import 'package:flutter_chart/chart/bar/bar_entry.dart';

/// FileName bar_data_provider
///
/// @Author junhua
/// @Date 2024/3/27
abstract class IBarDataProvider<T extends BarEntry> {
  double getMinValue(T entry);

  double getMaxValue(T entry);
}

/// 默认的柱状图数据提供者，如果y值大于0，则上边界为y，下边界为0；如果y值小于0，则上边界为0，下边界为y
class DefaultBarDataProvider<T extends BarEntry> implements IBarDataProvider<T> {
  const DefaultBarDataProvider();

  @override
  double getMinValue(T entry) {
    if (entry.minValue != null) return entry.minValue!;
    return entry.y > 0 ? 0 : entry.y;
  }

  @override
  double getMaxValue(T entry) {
    if (entry.maxValue != null) return entry.maxValue!;
    return entry.y > 0 ? entry.y : 0;
  }
}
