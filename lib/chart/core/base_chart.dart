import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_custom_painter.dart';
import 'package:flutter_chart/chart/core/base_chart_render.dart';
import 'package:flutter_chart/chart/core/chart.dart';
import 'package:flutter_chart/chart/core/chart_gesture_container.dart';
import 'package:flutter_chart/chart/core/chart_gesture_manager.dart';
import 'package:flutter_chart/chart/core/chart_render_manager.dart';
import 'package:flutter_chart/chart/data/data_set.dart';

/// @Description 图表库基础类
///
/// @Author junhua
/// @Date 2023/8/1
abstract class BaseChart<Data> extends StatefulWidget {
  /// 图表数据合集
  final DataSet<Data> chartData;

  /// 图表的宽
  final double? width;

  /// 图表的高
  final double? height;

  /// 图表事件分发管理类，用于协同管理多个chart之间的事件交互
  final ChartGestureManager? gestureManager;

  /// 图表的属性列表, 用于当属性变化时，触发图表的重绘
  List<Object?> get chartProps;

  /// 构造函数
  const BaseChart(
    this.chartData, {
    super.key,
    this.width,
    this.height,
    this.gestureManager,
  });

  @override
  BaseChartState createState();

  bool shouldRepaint(covariant BaseChart oldDelegate) {
    return true;
  }
}

/// @Description widget的基础状态类
///
/// @Author junhua
/// @Date 2023/8/1
abstract class BaseChartState<Chart extends BaseChart> extends State<Chart>
    with TickerProviderStateMixin
    implements IChart {
  late ChartRenderManager chartManager = ChartRenderManager(this);
  ChartGestureManager? _gestureManager;

  /// 画笔的局部刷新
  StateSetter? paintStateSetter;

  @override
  void initState() {
    super.initState();
    _gestureManager ??= DefaultChartGestureContainer.of(context) ?? ChartGestureManager();
    _initChartRenderList();
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = LayoutBuilder(
      builder: (context, constraint) {
        double height = min(widget.height ?? double.maxFinite, constraint.maxHeight);
        double width = min(widget.width ?? double.maxFinite, constraint.maxWidth);

        return StatefulBuilder(builder: (context, setState) {
          paintStateSetter = setState;
          return CustomPaint(
            size: Size(width, height),
            painter: ChartCustomPainter(
              widget,
              (Canvas canvas, Size size) => {chartManager.dispatchDraw(canvas, size)},
            ),
          );
        });
      },
    );

    if (_gestureManager != null &&
        _gestureManager!.hasGestureListener &&
        DefaultChartGestureContainer.of(context) == null) {
      return DefaultChartGestureContainer(
        gestureManager: _gestureManager,
        child: layoutBuilder,
      );
    }
    return layoutBuilder;
  }

  @override
  void didUpdateWidget(covariant Chart oldWidget) {
    super.didUpdateWidget(oldWidget);
    var propsChange = !widget.chartProps.equals(oldWidget.chartProps) || isPropChange(oldWidget);
    if (propsChange) {
      // 如果数据源发生变化或者渲染的特性变化，重新初始化渲染列表
      _initChartRenderList();
    }
  }

  /// 子类可继承处理属性变化的情况
  bool isPropChange(BaseChart oldWidget) {
    return false;
  }

  /// 初始化图表渲染列表
  void _initChartRenderList() {
    clearRenderList();
    initRenderList();
  }

  /// 更新ui
  @override
  void update(VoidCallback fn) {
    if (mounted) {
      paintStateSetter?.call(fn);
    }
  }

  /// 获取vsync用于动画
  @override
  TickerProvider get vsync => this;

  @override
  IGestureManager get gestureManager => _gestureManager!;

  @override
  void dispose() {
    clearRenderList();
    super.dispose();
  }

  /// 初始化渲染列表
  void initRenderList();

  /// render添加到renderList列表中，在绘制时进行分发
  void registerRender(BaseChartRender render) {
    registerRenderList([render]);
  }

  /// render添加到renderList列表中，在绘制时进行分发
  void registerRenderList(List<BaseChartRender> renderList) {
    chartManager.registerRender(renderList);
  }

  /// 清空render列表，由于[_gestureManager]可用于多个图表的联动，
  /// 在清空render时，只需清空该chart中的render[curWidgetInteractRender]
  void clearRenderList() {
    chartManager.dispose();
  }

  /// 将全局的位置转换为本地位置
  @override
  Offset convertGlobalPosToLocal(Offset offset) {
    final chartBox = context.findRenderObject() as RenderBox;
    return chartBox.globalToLocal(offset);
  }
}
