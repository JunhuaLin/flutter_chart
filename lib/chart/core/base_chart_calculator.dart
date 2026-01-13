import 'package:flutter/widgets.dart';
import 'package:flutter_chart/chart/data/data_set.dart';

/// @Description 基础计算类
///
/// @Author junhua
/// @Date 2023/8/1
abstract class BaseChartCalculator<Data> {
  /// 可绘制的宽度
  double width = 0;

  /// 可绘制的高度
  double height = 0;

  /// 数据集合
  DataSet<Data> dataSet;

  /// 构造函数
  BaseChartCalculator(this.dataSet);

  /// 根据外部设置的大小，更新绘制大小
  @mustCallSuper
  void setChartSize(Size size) {
    width = size.width;
    height = size.height;
  }
}
