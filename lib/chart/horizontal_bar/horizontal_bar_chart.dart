import 'package:flutter_chart/chart/core/base_chart.dart';
import 'package:flutter_chart/chart/data/data_set.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/horizontal_bar/horizontal_bar_calculator.dart';
import 'package:flutter_chart/chart/horizontal_bar/horizontal_bar_render.dart';
import 'package:flutter_chart/chart/horizontal_bar/horizontal_bar_spec.dart';

/// @Description 横向柱状图
///
/// @Author junhua
/// @Date 2023/8/15
class HorizontalBarChart extends BaseChart<Entry<num, num>> {
  /// 表格特性
  final HorizontalBarSpec barSpec;

  /// x轴显示转换
  final AxisLabelProvider? xAxisLabelProvider;

  /// x轴副label显示转换
  final AxisLabelProvider? xSecondaryAxisLabelProvider;

  /// 构造函数
  ///
  /// [chartData] 图表数据
  /// [key] 图表key
  /// [barSpec] 柱状图的特性
  /// [xAxisLabelProvider] x轴数据
  /// [xSecondaryAxisLabelProvider] x轴副轴数据
  const HorizontalBarChart(
    DataSet<Entry<num, num>> chartData, {
    super.width,
    super.height,
    super.key,
    this.xAxisLabelProvider,
    this.xSecondaryAxisLabelProvider,
    this.barSpec = const HorizontalBarSpec(),
  }) : super(chartData);

  @override
  _HorizontalBarChartState createState() => _HorizontalBarChartState();

  @override
  List<Object?> get chartProps => [
        chartData,
        barSpec,
        xAxisLabelProvider,
        xSecondaryAxisLabelProvider,
      ];
}

/// @Description HorizontalBarChart的state状态
///
/// @Author junhua
/// @Date 2023/8/15
class _HorizontalBarChartState extends BaseChartState<HorizontalBarChart> {
  @override
  void initRenderList() {
    // barRender init
    var barCalculator = HorizontalBarCalculator(
      widget.chartData,
      barSpec: widget.barSpec,
      xAxisLabelProvider: widget.xAxisLabelProvider,
      xSecondaryAxisLabelProvider: widget.xSecondaryAxisLabelProvider,
    );
    final barRender = HorizontalBarRender(
      barCalculator,
      barSpec: widget.barSpec,
    );
    registerRender(barRender);
  }
}

/// 根据轴的数据，显示对应的值
typedef AxisLabelProvider = String Function(num xValue, num yValue, int index);
