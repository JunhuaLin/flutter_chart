import 'package:flutter_chart/chart/axis/axis_data_set.dart';
import 'package:flutter_chart/chart/bar/bar_entry.dart';

/// FileName bar_data_set
///
/// @Author junhua
/// @Date 2024/3/27
class BarChartData<T extends BarEntry> extends AxisDataSet<T> {
  BarChartData(
    List<T> data, {
    double? startIndex,
    double? displayCount,
  }) : super(
          data,
          startIndex: startIndex,
          displayCount: displayCount,
        );

  @override
  void calculateMinMaxY(T entry) {
    var minValue = entry.minValue;
    if (minValue != null) {
      if (minValue < minY) {
        minY = minValue;
      }
    } else {
      if (entry.y < minY) {
        minY = entry.y;
      }
    }

    var maxValue = entry.maxValue;
    if (maxValue != null) {
      if (maxValue > maxY) {
        maxY = maxValue;
      }
    } else {
      if (entry.y > maxY) {
        maxY = entry.y;
      }
    }
  }
}

typedef BarValueProvider<T> = double Function(T entry);
