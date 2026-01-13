import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/axis/axis_data_set.dart';
import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/axis/xaxis_render.dart';
import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/axis/yaxis_render.dart';
import 'package:flutter_chart/chart/behavior/behavior_callback.dart';
import 'package:flutter_chart/chart/chart_const.dart';
import 'package:flutter_chart/chart/content/high_low_label/high_and_low_calculator.dart';
import 'package:flutter_chart/chart/content/high_low_label/high_and_low_label_content_render.dart';
import 'package:flutter_chart/chart/content/high_low_label/high_and_low_label_spec.dart';
import 'package:flutter_chart/chart/core/base_chart.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_calculator.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_render.dart';
import 'package:flutter_chart/chart/cross_stitch/cross_stitch_spec.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/provider/axis_value_provider.dart';
import 'package:flutter_chart/chart/provider/item_margin_provider.dart';
import 'package:flutter_chart/chart/push/push_point_render.dart';
import 'package:flutter_chart/chart/push/push_point_spec.dart';

/// @Description 包含x,y轴图形chart
///
/// @Author junhua
/// @Date 2023/8/3
abstract class XYComponentChart extends BaseChart<Entry<double, double>> {
  /// x轴特性
  final AxisSpec xAxisSpec;

  /// y轴特性
  final AxisSpec yAxisSpec;

  /// x,y数据
  final AxisDataSet axisDataSet;

  /// x,y轴显示的数据转换，返回的是索引值
  final AxisIndexProvider<AxisDataSet>? xAxisIndexProvider;

  /// x,y轴显示的数据转换，返回的是显示的值
  final AxisValueProvider<AxisDataSet>? xAxisValueProvider;

  /// x,y轴显示的数据转换
  final AxisIndexProvider<AxisDataSet>? yAxisIndexProvider;

  /// x,y轴显示的数据转换
  final AxisValueProvider<AxisDataSet>? yAxisValueProvider;

  /// 可从外部传入contents
  final List<XYChartContent>? contentRenderList;

  /// 十字针特性
  final CrossStitchSpec? crossStitchSpec;

  /// 十字针操作的回调
  final OnLongPressCallback? onCrossStitchMovingCallback;

  /// 移动操作的回调
  final OnTransformCallBack? onMoveCallback;

  /// 缩放操作的回调ui
  final OnTransformCallBack? onScaleCallback;

  /// 支持十字针显示
  final bool enableCrossStitch;

  /// 支持图表移动
  final bool enableMove;

  /// 支持图表缩放
  final bool enableScale;

  /// 是否支持推送动画
  final bool enablePushAnimation;

  /// 推送点特性
  final PushPointSpec? pushPointSpec;

  /// 推送点
  final Entry<double, double>? pushEntry;

  /// itemMargin的提供
  final ItemMarginProvider? itemMarginProvider;

  /// 最高最低点的标签绘制特性
  final HighAndLowLabelSpec highAndLowLabelSpec;

  /// 是否显示最高最低标签
  final bool showHighAndLowLabel;

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
  /// [onCrossStitchMovingCallback] 十字针操作回调
  /// [enableMove] 是否支持移动
  /// [onMoveCallback] 移动回调
  /// [enableScale] 是否支持缩放
  /// [onScaleCallback] 缩放回调
  /// [enablePushAnimation] 是否支持推送动画
  /// [pushPoint] 推送点，如不设置推送点，则默认使用最后一个有效数据
  /// [pushPointSpec] 推送点特性
  /// [itemMarginProvider] itemMargin的提供，用于提供外部可动态修改item之间的间隔
  /// [showHighAndLowLabel] 是否显示最高最低点的标签
  /// [highAndLowLabelSpec] 最高最低点的标签绘制特性
  const XYComponentChart(
    this.axisDataSet, {
    required this.xAxisSpec,
    required this.yAxisSpec,
    super.key,
    super.width,
    super.height,
    super.gestureManager,
    this.xAxisIndexProvider,
    this.xAxisValueProvider,
    this.yAxisValueProvider,
    this.yAxisIndexProvider,
    this.contentRenderList,
    this.enableCrossStitch = false,
    this.crossStitchSpec,
    this.onCrossStitchMovingCallback,
    this.enableMove = false,
    this.onMoveCallback,
    this.enableScale = false,
    this.onScaleCallback,
    this.enablePushAnimation = false,
    this.pushEntry,
    this.pushPointSpec = const PushPointSpec(),
    this.itemMarginProvider,
    this.showHighAndLowLabel = false,
    this.highAndLowLabelSpec = const HighAndLowLabelSpec(),
  }) : super(
          axisDataSet,
        );
}

/// @Description xy表格的state
///
/// @Author junhua
/// @Date 2023/8/3
class XYComponentChartState<T extends XYComponentChart> extends BaseChartState<T> {
  /// 包含x, y轴calculator的信息
  late AxisContextCalculator axisContext;

  /// 推送点
  PushPointRender? pushPointRender;

  @override
  @mustCallSuper
  void initRenderList() {
    // x, y轴信息
    axisContext = AxisContextCalculator(
      widget.axisDataSet,
      xAxisSpec: widget.xAxisSpec,
      yAxisSpec: widget.yAxisSpec,
      xAxisIndexProvider: widget.xAxisIndexProvider,
      xAxisValueProvider: widget.xAxisValueProvider,
      yAxisIndexProvider: widget.yAxisIndexProvider,
      yAxisValueProvider: widget.yAxisValueProvider,
      itemMarginProvider: widget.itemMarginProvider,
    );

    // x轴渲染
    XAxisRender xAxisRender = XAxisRender(
      axisContext,
      level: ChartConst.axisLevel,
      axisSpec: widget.xAxisSpec,
      enableMove: widget.enableMove,
      enableScale: widget.enableScale,
      onMoveCallback: widget.onMoveCallback,
      onScaleCallback: widget.onScaleCallback,
    );
    registerRender(xAxisRender);

    // y轴渲染
    YAxisRender yAxisRender = YAxisRender(
      axisContext,
      level: ChartConst.axisLevel,
      axisSpec: widget.yAxisSpec,
    );
    registerRender(yAxisRender);

    // 十字针render绘制
    if (widget.enableCrossStitch) {
      registerRender(initCrossStitchRender(CrossStitchCalculator(widget.chartData, axisContext)));
    }

    var xyComponentCalculator = XYComponentCalculator(widget.axisDataSet, axisContext);
    // x,y轴的内容渲染
    if (widget.contentRenderList != null) {
      XYChartContentRenderContainer contentRenderContainer = XYChartContentRenderContainer(
        xyComponentCalculator,
        contents: widget.contentRenderList!,
      );
      registerRender(contentRenderContainer);
    }

    // 最高和最低价格标签
    if (widget.showHighAndLowLabel) {
      registerRender(HighAndLowLabelContentRender(
        HighAndLowCalculator(widget.chartData, axisContext, spec: widget.highAndLowLabelSpec),
        highAndLowLabelSpec: widget.highAndLowLabelSpec,
      ));
    }

    // 推送动画
    if (widget.enablePushAnimation) {
      pushPointRender = initPushPointRender(
        xyComponentCalculator,
        widget.pushPointSpec ?? const PushPointSpec(),
      );
      registerRender(pushPointRender!);
      pushPointRender!.startAnimation();
    }
  }

  /// 注册十字针，子类可实现不同的十字针
  CrossStitchRender initCrossStitchRender(CrossStitchCalculator crossStitchCalculator) {
    return CrossStitchRender(
      crossStitchCalculator,
      level: ChartConst.crossStitchLevel,
      longPressCallback: widget.onCrossStitchMovingCallback,
      crossSpec: widget.crossStitchSpec ?? const CrossStitchSpec(),
    );
  }

  /// 初始化动画render，子类可实现不同的动画形式
  PushPointRender initPushPointRender(
    XYComponentCalculator calculator,
    PushPointSpec pushPointSpec,
  ) {
    return PushPointRender(
      calculator,
      spec: pushPointSpec,
      pushEntry: widget.pushEntry,
    );
  }

  @override
  bool isPropChange(BaseChart oldWidget) {
    return widget.axisDataSet.dataHasChange;
  }
}
