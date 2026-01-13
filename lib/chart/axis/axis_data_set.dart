import 'dart:math';

import 'package:flutter_chart/chart/data/data_set.dart';
import 'package:flutter_chart/chart/data/entry.dart';

/// @Description 坐标轴的数据
///
/// @Author junhua
/// @Date 2023/8/16
abstract class AxisDataSet<TEntry extends Entry<double, double>> extends DataSet<TEntry> {
  /// x轴的最小值
  double minX = double.maxFinite;

  /// y轴的最小值
  double minY = double.maxFinite;

  /// x轴的最大值
  double maxX = double.negativeInfinity;

  /// y轴的最大值
  double maxY = double.negativeInfinity;

  /// 绘制的开始坐标
  double? startIndex;

  /// 绘制的数目
  double? displayCount;

  /// 缩放的比例
  double scaleFactor = 1.0;

  /// 上次缩放的比例
  double lastScaleFactor = 1.0;

  /// 缩放点所在点的index
  double scaleFocusIndex = -1;

  /// 缩放点的比例
  double scaleFocusRadio = 0.5;

  /// 标记数据源是否发生变化,用于进行动画推送的显示
  bool get dataHasChange => _dataHasChange;

  /// x轴的比较器
  Comparator<TEntry> xValueComparator = (TEntry o1, TEntry o2) => o1.x.compareTo(o2.x);

  bool _dataHasChange = false;

  AxisDataSet(
    super.data, {
    this.startIndex,
    this.displayCount,
  });

  void calculateMinMaxAxisValues() {
    _calculateMinMaxAxisValues(
      startIndex,
      displayCount,
      scaleFactor: scaleFactor,
    );
  }

  /// 计算数据的最小最大值
  void _calculateMinMaxAxisValues(double? startIndex, double? displayCount,
      {double scaleFactor = 1.0}) {
    if (data.isEmpty) {
      return;
    }

    double realStartIndex = startIndex ?? 0;
    double realDisplayCount =
        displayCount == null ? data.length.toDouble() : (displayCount / scaleFactor);
    int endIndex = min((realStartIndex + realDisplayCount).ceil(), data.length);

    _restMinMaxValues();
    for (int i = realStartIndex.toInt(); i < endIndex; i++) {
      TEntry entry = data[i];
      if (!entry.isValid) {
        continue;
      }

      calculateMinMaxX(entry);
      calculateMinMaxY(entry);
    }

    /// 重新计算数据时，数据已确认发生变化
    _markDataChanged();
  }

  /// 计算x方向的最小值和最大值
  void calculateMinMaxX(TEntry entry) {
    if (entry.x < this.minX) {
      this.minX = entry.x;
    }

    if (entry.x > this.maxX) {
      this.maxX = entry.x;
    }
  }

  /// 计算y方向的最小值和最大值
  void calculateMinMaxY(TEntry entry) {
    if (entry.y < this.minY) {
      this.minY = entry.y;
    }

    if (entry.y > this.maxY) {
      this.maxY = entry.y;
    }
  }

  /// 增加数据, 实时更新[startIndex]值，保证数据的连续性
  /// [newData] 新数据列表
  /// [isEnd] 是否是加到末尾
  void insertData(List<TEntry> newData, {bool isEnd = true}) {
    if (newData.isEmpty) {
      return;
    }

    if (isEnd) {
      data.addAll(newData);
    } else {
      data.insertAll(0, newData);
      startIndex = newData.length + (startIndex ?? 0);
    }

    _dataHasChange = true;
  }

  /// 标记当前数据源的变化已处理
  void _markDataChanged() {
    _dataHasChange = false;
  }

  void _restMinMaxValues() {
    minX = double.maxFinite;
    minY = double.maxFinite;
    maxX = double.negativeInfinity;
    maxY = double.negativeInfinity;
  }
}
