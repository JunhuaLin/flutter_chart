import 'dart:ui';

import 'package:flutter_chart/chart/core/base_chart_render.dart';
import 'package:flutter_chart/chart/core/chart.dart';

/// @Description 负责chart 列表的管理
///
/// @Author junhua
/// @Date 2023/8/15
class ChartRenderManager {
  /// render的绘制列表
  final List<BaseChartRender> renderList = [];

  final IChart _chart;

  ChartRenderManager(IChart chart) : _chart = chart;

  /// 绘制分发到每个render
  void dispatchDraw(
    Canvas canvas,
    Size size,
  ) {
    for (var render in renderList) {
      render.draw(canvas, size);
    }
  }

  /// 注册render到列表中
  void registerRender(List<BaseChartRender> renders) {
    // Render关联图表
    for (final render in renders) {
      render.attachChart(
        _chart,
      );
    }
    renderList.addAll(renders);
    renderList.sort((a, b) => a.level - b.level);
  }

  /// 释放资源
  void dispose() {
    for (var render in renderList) {
      render.dispose();
    }
    renderList.clear();
  }
}
