import 'package:flutter_chart/chart/axis/axis_data_set.dart';

/// @Description 用于对坐标轴显示进行转换
///
/// @Author junhua
/// @Date 2023/8/10
class AxisValueProvider<T extends AxisDataSet> {
  /// 用于轴的数据显示转换，如进行日期的切换
  StringProvider? axisValueFormatter;

  /// 用于提供轴数据列表
  ListProvider<T>? axisValueProvider;

  AxisValueProvider({
    this.axisValueFormatter,
    this.axisValueProvider,
  });
}

/// 用于对x轴的index进行转换
class AxisIndexProvider<T extends AxisDataSet> {
  /// 用于轴的数据显示转换，如进行日期的切换
  StringProvider? axisValueFormatter;

  /// 用于提供轴数据列表
  ListIndexProvider<T>? axisIndexProvider;

  AxisIndexProvider({
    this.axisValueFormatter,
    this.axisIndexProvider,
  });
}

/// [value] 当前item的值
/// [startIndex] 绘制开始的index值
/// [totalCount] 总共需要显示的item的数目
typedef StringProvider = String Function(double value, double startIndex, double totalCount);

/// 返回显示的坐标轴的数据
typedef ListProvider<T extends AxisDataSet> = List<double> Function(
  // 原始数据源
  T ds,
  // 在当前页面需要显示item的数目
  double displayCount,
  // 当前页面开始的index值
  double startIndex,
);

/// 返回index的列表
typedef ListIndexProvider<T extends AxisDataSet> = List<int> Function(
  // 原始数据源
  T ds,
  // 在当前页面需要显示item的数目
  double displayCount,
  // 当前页面开始的index值
  double startIndex,
);
