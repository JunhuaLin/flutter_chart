import 'package:flutter_chart/flutter_chart.dart';

/// FileName time_sharing_data
///
/// @Author junhua
/// @Date 2024/4/2
class TimeSharingDay {
  /// 当前日期
  double dayTime;

  /// 分时数据
  List<SectionList> selectionList;

  TimeSharingDay(this.dayTime, this.selectionList);
}

class SectionList {
  /// 分时数据
  List<TimeSharingPoint> selectionList;

  /// 上一个收盘价
  double lastClosePrice;

  SectionList({
    required this.selectionList,
    required this.lastClosePrice,
  });
}
