import 'package:flutter_chart/chart/axis/axis_data_set.dart';
import 'package:flutter_chart/chart/tick/tick_item_entry.dart';

/// FileName tick_data_set
///
/// @Author junhua
/// @Date 2024/4/3
/// @Description 逐笔数据集
class TickDataset extends AxisDataSet<TickItemEntry> {
  /// tick数据
  final List<TickItemEntry> tickItems;

  TickDataset(
    this.tickItems, {
    double? startIndex,
    double? displayCount,
  }) : super(
          tickItems,
          startIndex: startIndex,
          displayCount: displayCount,
        );
}
