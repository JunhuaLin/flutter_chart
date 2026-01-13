import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/axis/xy_component_chart.dart';
import 'package:flutter_chart/chart/chart_const.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_calculator.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_render.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_spec.dart';
import 'package:flutter_chart/chart/cross_stitch/time_sharing_cross_stitch_render.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_calculator.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_content_render.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_dataset.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_entry.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_spec.dart';

/// FileName TimeSharingChart
///
/// @Author junhua
/// @Date 2024/4/1
/// @Description 分时图
class TimeSharingChart extends XYComponentChart {
  /// 蜡烛图特性
  final TimeSharingSpec timeSharingSpec;

  /// 蜡烛图数据
  final TimeSharingDataSet timeSharingData;

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
  /// [timeSharingSpec] 蜡烛图的特性
  /// [contentRender] 图表内容的绘制,提供给外部绘制的能力
  const TimeSharingChart(
    this.timeSharingData, {
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
    this.timeSharingSpec = const TimeSharingSpec(),
    super.itemMarginProvider,
    super.highAndLowLabelSpec,
    super.showHighAndLowLabel,
  }) : super(
          timeSharingData,
          xAxisSpec: xAxisSpec ?? const AxisSpec(),
          yAxisSpec: yAxisSpec ?? const AxisSpec(),
        );

  @override
  _TimeSharingChartState createState() => _TimeSharingChartState();

  @override
  List<Object?> get chartProps => [
        timeSharingData,
        timeSharingSpec,
        crossStitchSpec,
        pushEntry,
        xAxisSpec,
        yAxisSpec,
        pushPointSpec,
        showHighAndLowLabel,
      ];
}

class _TimeSharingChartState extends XYComponentChartState<TimeSharingChart> {
  @override
  void initRenderList() {
    super.initRenderList();
    var timeSharingCalculator = TimeSharingCalculator(
      widget.timeSharingData,
      axisContext,
      showAvgLine: widget.timeSharingSpec.showAverageLine,
    );
    registerRender(TimeSharingContentRender(
      timeSharingCalculator,
      spec: widget.timeSharingSpec,
    ));
  }

  @override
  CrossStitchRender initCrossStitchRender(CrossStitchCalculator crossStitchCalculator) {
    return TimeSharingCrossStitchRender(
      crossStitchCalculator,
      level: ChartConst.crossStitchLevel,
      crossSpec: widget.crossStitchSpec ?? const CrossStitchSpec(),
      longPressCallback: widget.onCrossStitchMovingCallback,
      showAverageLine: widget.timeSharingSpec.showAverageLine,
      priceLineColor: widget.timeSharingSpec.priceLineColor,
      avgLineColor: widget.timeSharingSpec.avgLineColor,
      priceProvider: (TimeSharingEntry entry, int index) => entry.close,
      avgPriceProvider: (TimeSharingEntry entry, int index) => entry.average,
    );
  }
}
