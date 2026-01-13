import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/axis/xy_component_chart.dart';
import 'package:flutter_chart/chart/bar/bar_calculator.dart';
import 'package:flutter_chart/chart/bar/bar_chart_content_render.dart';
import 'package:flutter_chart/chart/bar/bar_chart_data.dart';
import 'package:flutter_chart/chart/bar/bar_spec.dart';
import 'package:flutter_chart/chart/chart_const.dart';

/// @Description 柱状图
///
/// @Author junhua
/// @Date 2023/8/15
class BarChart extends XYComponentChart {
  /// 表格特性
  final BarSpec barSpec;

  /// 柱状图数据
  final BarChartData barChartData;

  /// 构造函数
  ///
  /// [chartData] 图表数据
  /// [size] 图表大小
  /// [key] 图表key
  /// [behaviorCallBack] 图表操作的回调
  /// [xAxisValueProvider] x轴数据转显示
  /// [yAxisValueProvider] y轴数据转显示
  /// [gestureManager] 图表交互管理，如果不传入，则每个图表使用自己的交互管理，当多图需要联动时，需要创建同一个传入
  /// [xAxisSpec] x轴特性设置
  /// [yAxisSpec] y轴特性设置
  /// [crossStitchSpec] 十字针特性
  /// [barSpec] 柱状图的特性
  /// [contentRender] 图表内容的绘制,提供给外部绘制的能力
  const BarChart(
    this.barChartData, {
    super.width,
    super.height,
    super.key,
    super.onCrossStitchMovingCallback,
    super.onMoveCallback,
    super.onScaleCallback,
    super.xAxisIndexProvider,
    super.xAxisValueProvider,
    super.yAxisIndexProvider,
    super.yAxisValueProvider,
    super.gestureManager,
    super.contentRenderList,
    super.crossStitchSpec,
    super.enableMove,
    super.enableScale,
    super.enableCrossStitch,
    AxisSpec? xAxisSpec,
    AxisSpec? yAxisSpec,
    this.barSpec = const BarSpec(),
    super.itemMarginProvider,
    super.highAndLowLabelSpec,
    super.showHighAndLowLabel,
  }) : super(
          barChartData,
          xAxisSpec: xAxisSpec ?? const AxisSpec(),
          yAxisSpec: yAxisSpec ?? const AxisSpec(),
        );

  @override
  _BarChartState createState() => _BarChartState();

  @override
  List<Object?> get chartProps => [
        barChartData,
        barSpec,
        xAxisSpec,
        yAxisSpec,
        showHighAndLowLabel,
      ];
}

/// @Description BarChart的state状态
///
/// @Author junhua
/// @Date 2023/8/15
class _BarChartState extends XYComponentChartState<BarChart> {
  @override
  void initRenderList() {
    super.initRenderList();

    // barRender init
    var barCalculator = BarCalculator(
      widget.barChartData,
      axisContext,
      barSpec: widget.barSpec,
    );
    registerRender(BarChartContentRender(
      barCalculator,
      barSpec: widget.barSpec,
      level: ChartConst.barLevel,
    ));
  }
}
