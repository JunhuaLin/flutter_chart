import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/axis/xy_component_chart.dart';
import 'package:flutter_chart/chart/candle/candle_stick_calculator.dart';
import 'package:flutter_chart/chart/candle/candle_stick_chart_data.dart';
import 'package:flutter_chart/chart/candle/candle_stick_content_render.dart';
import 'package:flutter_chart/chart/candle/candle_stick_spec.dart';

/// FileName candle_stick_chart
///
/// @Author junhua
/// @Date 2024/3/11
/// 蜡烛图
class CandleStickChart extends XYComponentChart {
  /// 蜡烛图特性
  final CandleStickSpec candleStickSpec;

  /// 蜡烛图数据
  final CandleStickChartData candleData;

  /// 蜡烛图最高最低文本展示转换
  final ValueFormatter candleValueProvider;

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
  /// [candleStickSpec] 蜡烛图的特性
  /// [candleValueProvider] 蜡烛图最高最低文本展示转换
  const CandleStickChart(
    this.candleData, {
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
    super.enableCrossStitch,
    super.enableMove = true,
    super.enableScale = true,
    super.enablePushAnimation,
    super.pushPointSpec,
    AxisSpec? xAxisSpec,
    AxisSpec? yAxisSpec,
    required this.candleStickSpec,
    required this.candleValueProvider,
    super.itemMarginProvider,
  }) : super(
          candleData,
          xAxisSpec: xAxisSpec ?? const AxisSpec(),
          yAxisSpec: yAxisSpec ?? const AxisSpec(),
        );

  @override
  _CandleStickChartState createState() => _CandleStickChartState();

  @override
  List<Object?> get chartProps => [
        candleData,
        candleStickSpec,
        xAxisSpec,
        yAxisSpec,
      ];
}

class _CandleStickChartState extends XYComponentChartState<CandleStickChart> {
  @override
  void initRenderList() {
    super.initRenderList();
    var candleCalculator = CandleStickCalculator(widget.candleData, axisContext);
    registerRender(CandleStickContentRender(
      candleCalculator,
      widget.candleStickSpec,
      widget.candleValueProvider,
    ));
  }
}

typedef ValueFormatter = String Function(double value);
