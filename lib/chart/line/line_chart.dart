import 'package:flutter_chart/chart/axis/axis_data_set.dart';
import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/axis/xy_component_chart.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/line/line_content_render.dart';
import 'package:flutter_chart/chart/line/line_spec.dart';

/// @Description 折线图
///
/// @Author junhua
/// @Date 2023/8/2
class LineChart extends XYComponentChart {
  /// 折线特性
  final LineSpec lineSpec;

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
  /// [lineSpec] 折线特性
  /// [crossStitchSpec] 十字针特性
  /// [contentRender] 图表内容的绘制,提供给外部绘制的能力
  const LineChart(
    AxisDataSet chartData, {
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
    super.enableMove,
    super.enableScale,
    super.crossStitchSpec,
    super.enableCrossStitch,
    super.enablePushAnimation,
    super.pushPointSpec,
    AxisSpec? xAxisSpec,
    AxisSpec? yAxisSpec,
    this.lineSpec = const LineSpec(),
    super.itemMarginProvider,
    super.highAndLowLabelSpec,
    super.showHighAndLowLabel = false,
  }) : super(
          chartData,
          xAxisSpec: xAxisSpec ?? const AxisSpec(),
          yAxisSpec: yAxisSpec ?? const AxisSpec(),
        );

  @override
  _LineChartState createState() => _LineChartState();

  @override
  List<Object?> get chartProps => [
        chartData,
        xAxisSpec,
        yAxisSpec,
        lineSpec,
        showHighAndLowLabel,
      ];
}

/// @Description 折线图state
///
/// @Author junhua
/// @Date 2023/8/2
class _LineChartState extends XYComponentChartState<LineChart> {
  @override
  void initRenderList() {
    super.initRenderList();

    // lineRender init
    var lineCalculator = XYComponentCalculator(widget.axisDataSet, axisContext);
    registerRender(LinetContentRender(
      lineCalculator,
      lineSpec: widget.lineSpec,
    ));
  }
}
