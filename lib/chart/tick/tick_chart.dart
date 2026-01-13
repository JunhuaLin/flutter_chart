import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/axis/xy_component_chart.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/tick/tick_chart_content_render.dart';
import 'package:flutter_chart/chart/tick/tick_chart_spec.dart';
import 'package:flutter_chart/chart/tick/tick_data_set.dart';
import 'package:flutter_chart/chart/tick/tick_item_entry.dart';

/// FileName tick_chart
///

/// @Date 2024/4/1
/// @Description tick图
class TickChart extends XYComponentChart {
  /// Tick图特性
  final TickChartSpec tickChartSpec;

  /// Tick图数据
  final TickDataset tickChartData;

  /// 构造函数
  ///
  /// [axisDataSet] 图表数据
  /// [xAxisIndexProvider] x轴的索引值提供，提供的是坐标的index值，如需要第一个和最后一个数据，则为[0, length - 1]
  /// [xAxisValueProvider] x轴的索引值提供，提供的是坐标的value值，，如需要第一个和最后一个数据，则为[data[0], data[length - 1]
  /// [yAxisIndexProvider] y轴的索引值提供，提供的是坐标的index值，如需要第一个和最后一个数据，则为[0, length - 1]
  /// [yAxisValueProvider] y轴的索引值提供，提供的是坐标的value值，，如需要第一个和最后一个数据，则为[data[0], data[length - 1]
  /// [contentRenderList] 外部可设置的绘制render列表
  /// [crossStitchSpec] 十字针特性
  /// [enableCrossStitch] 是否显示十字针
  /// [crossStitchSpec] 十字针特性
  /// [crossStitchMovingCallback] 十字针操作回调
  /// [enableMove] 是否支持移动
  /// [moveCallBack] 移动回调
  /// [enableScale] 是否支持缩放
  /// [scaleCallBack] 缩放回调
  /// [enablePushAnimation] 是否支持推送动画
  /// [pushPoint] 推送点，如不设置推送点，则默认使用最后一个有效数据
  /// [pushPointSpec] 推送点特性
  /// [itemMarginProvider] itemMargin的提供，用于提供外部可动态修改item之间的间隔
  /// [showHighAndLowLabel] 是否显示最高最低点的标签
  /// [highAndLowLabelSpec] 最高最低点的标签绘制特性
  /// [tickChartSpec] Tick图特性
  /// [tickChartData] Tick图数据
  const TickChart(
    this.tickChartData, {
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
    super.enableCrossStitch,
    super.enableMove = false,
    super.enableScale = false,
    super.enablePushAnimation,
    super.pushPointSpec,
    super.crossStitchSpec,
    AxisSpec? xAxisSpec,
    AxisSpec? yAxisSpec,
    super.pushEntry,
    this.tickChartSpec = const TickChartSpec(),
    super.itemMarginProvider,
    super.highAndLowLabelSpec,
    super.showHighAndLowLabel = true,
  }) : super(
          tickChartData,
          xAxisSpec: xAxisSpec ?? const AxisSpec(),
          yAxisSpec: yAxisSpec ?? const AxisSpec(),
        );

  @override
  _TickChartState createState() => _TickChartState();

  @override
  List<Object?> get chartProps => [
        tickChartData,
        tickChartSpec,
        crossStitchSpec,
        pushEntry,
        xAxisSpec,
        yAxisSpec,
        pushPointSpec,
        enableMove,
        enableScale,
        enablePushAnimation,
        showHighAndLowLabel,
        highAndLowLabelSpec,
      ];
}

class _TickChartState extends XYComponentChartState<TickChart> {
  @override
  void initRenderList() {
    super.initRenderList();
    registerRender(TickChartContentRender(
      XYComponentCalculator<TickItemEntry>(widget.tickChartData, axisContext),
      tickChartSpec: widget.tickChartSpec,
    ));
  }
}
