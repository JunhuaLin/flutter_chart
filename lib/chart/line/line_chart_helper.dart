import 'package:flutter_chart/chart/data/axis_min_max_values.dart';
import 'package:flutter_chart/chart/data/entry.dart';

/// @Description 用于计算最大值，最小值
///
/// @Author junhua
/// @Date 2023/8/16
class LineChartHelper {
  /// 计算数据的最小，最大值
  static AxisMinMaxAxisValues calculateMaxAxisValues(
    List<Entry<num, num>> lineChartData,
  ) {
    if (lineChartData.isEmpty) {
      return const AxisMinMaxAxisValues(0, 0, 0, 0);
    }

    num minX = double.maxFinite;
    num maxX = double.negativeInfinity;
    num minY = double.maxFinite;
    num maxY = double.negativeInfinity;

    for (int i = 0; i < lineChartData.length; i++) {
      Entry<num, num> entry = lineChartData[i];
      if (!entry.isValid) {
        continue;
      }

      if (entry.x < minX) {
        minX = entry.x;
      }

      if (entry.x > maxX) {
        maxX = entry.x;
      }

      if (entry.y < minY) {
        minY = entry.y;
      }

      if (entry.y > maxY) {
        maxY = entry.y;
      }
    }

    final result = AxisMinMaxAxisValues(
      minX.toDouble(),
      maxX.toDouble(),
      minY.toDouble(),
      maxY.toDouble(),
    );
    return result;
  }
}
