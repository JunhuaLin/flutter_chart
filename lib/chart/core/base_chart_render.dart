import 'package:flutter/widgets.dart';
import 'package:flutter_chart/chart/chart_const.dart';
import 'package:flutter_chart/chart/core/base_chart_calculator.dart';
import 'package:flutter_chart/chart/core/chart.dart';

/// @Description Render基础类
///
/// @Author junhua
/// @Date 2023/8/1
abstract class BaseChartRender<Calculator extends BaseChartCalculator> {
  /// 绘制层级,level越高放在视图最后面
  final int level;

  /// 默认的render计算类
  final Calculator calculator;

  /// 图表接口
  late IChart _chart;

  /// 图表能力
  IChart get chart => _chart;

  /// 记录图表的size
  Size _size = Size.zero;

  /// 图表大小
  Size get size => _size;

  BaseChartRender(this.calculator, {this.level = ChartConst.defaultDrawLevel});

  /// 关联图表
  void attachChart(IChart chart) {
    this._chart = chart;
    onInit(chart);
  }

  /// render继承实现具体初始化逻辑
  void onInit(IChart chart) {}

  /// 绘制方法，更新大小
  void draw(Canvas canvas, Size size) {
    if (_size != size) {
      _onSizeChange(size);
      _size = size;
    }
    onDraw(canvas, size);
  }

  /// 图表大小变化时设置
  void _onSizeChange(Size size) {
    calculator.setChartSize(size);
  }

  /// render继承实现具体的绘制逻辑
  void onDraw(Canvas canvas, Size size);

  /// 刷新图表
  /// 非[onDraw]的情况下调用触发重绘
  void update([VoidCallback? fn]) {
    _chart.update(() {
      fn?.call();
    });
  }

  /// 全局坐标转换到本地坐标
  Offset convertGlobalToLocal(Offset globalOffset) {
    return _chart.convertGlobalPosToLocal(globalOffset);
  }

  /// 释放资源
  void dispose() {}
}
