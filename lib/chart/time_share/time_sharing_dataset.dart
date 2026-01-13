import 'package:collection/collection.dart';
import 'package:flutter_chart/chart/bar/bar_chart_data.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_entry.dart';

/// 分时图数据集
///
/// @Author junhua
/// @Date 2024/4/1
class TimeSharingDataSet extends BarChartData<TimeSharingEntry> {
  /// 前一天的收盘价
  final double lastClosePrice;

  /// 分时
  final List<TimeSelection> selections;

  /// 当前价格
  double currentPrice = 0;

  TimeSharingDataSet({
    required this.lastClosePrice,
    required this.selections,
    double? startIndex,
    double? displayCount,
  }) : super(
          selections.expand((element) => element.entries).toList(),
          startIndex: startIndex,
          displayCount: displayCount,
        );

  /// 添加数据
  bool addEntry(TimeSharingEntry entry) {
    if (selections.isNotEmpty) {
      for (TimeSelection selection in selections) {
        if (selection.addEntry(entry)) {
          calculateMinMaxY(entry);
          return true;
        }
      }
    }

    return false;
  }

  /// 更新数据
  bool updateEntry(TimeSharingEntry entry) {
    if (selections.isNotEmpty) {
      for (TimeSelection selection in selections) {
        if (selection.update(entry, xValueComparator)) {
          calculateMinMaxY(entry);
          return true;
        }
      }
    }

    return false;
  }
}

/// FileName time_selection
///
/// @Author junhua
/// @Date 2024/4/1
/// @Description 分时时段
class TimeSelection {
  /// 开始时间
  int startTime;

  /// 结束时间
  int endTime;

  /// 分时时段
  List<TimeSharingEntry> entries = [];

  /// 是否时间段内存在有效数据
  bool hasValidEntry = false;

  /// 分时时段内，数据个数
  int get entryCount => entries.length;

  TimeSelection({
    required this.startTime,
    required this.endTime,
  });

  /// 增加分时图数据
  bool addEntry(TimeSharingEntry entry) {
    if (_isInSelection(entry.time)) {
      hasValidEntry = hasValidEntry || entry.isValid;
      entries.add(entry);
      return true;
    }

    return false;
  }

  /// 更新分时图数据
  bool update(TimeSharingEntry updateEntry, Comparator<TimeSharingEntry> comparator) {
    if (_isInSelection(updateEntry.time) && entries.isNotEmpty) {
      final index = binarySearch(entries, updateEntry, compare: comparator);
      if (index > 0) {
        if (entries[index].update(updateEntry)) {
          hasValidEntry = hasValidEntry || updateEntry.isValid;
          return true;
        }
      }
    }

    return false;
  }

  bool _isInSelection(int time) {
    return time >= startTime && time <= endTime;
  }

  @override
  String toString() {
    return "TimeSelection{startTime: $startTime, endTime: $endTime}";
  }
}
