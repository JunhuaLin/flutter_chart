import 'dart:ui';

import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/common/dash_painter.dart';
import 'package:flutter_chart/chart/content/index/index_line_data.dart';
import 'package:flutter_chart/chart/content/index/index_line_spec.dart';
import 'package:flutter_chart/chart/data/entry.dart';

/// FileName index_draw_line_content
///
/// @Author junhua
/// @Date 2024/3/13
class IndexDrawLineContent implements XYChartContent {
  /// 绘制的数据
  IndexLineData indexLineData;

  /// 绘制的线的特性
  IndexLineSpec indexLineSpec;

  /// 绘制的线画笔
  final Paint _linePaint;

  /// 绘制虚线的画笔
  final DashPainter _dashPainter;

  /// 绘制的线路径
  final Path _linePath = Path();

  IndexDrawLineContent(
    this.indexLineData, {
    this.indexLineSpec = const IndexLineSpec(),
  })  : _linePaint = Paint()
          ..color = indexLineSpec.lineColor
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = indexLineSpec.lineWidth,
        _dashPainter = DashPainter(
          dashWidth: indexLineSpec.dashWidth,
          dashSpan: indexLineSpec.dashSpan,
        );

  @override
  void drawContent(
    Canvas canvas,
    XYComponentCalculator<Entry<double, double>> calculator,
    double width,
    double height,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    int firstPointIndex = end;
    for (int i = firstPointIndex; i < end; i++) {
      // 寻找第一个有效绘制的点，由于ma50的数据是从第50个数据开始的，所以需要找到第一个有效的点
      if (indexLineData.data[i].x != null && indexLineData.data[i].y != null) {
        firstPointIndex = i;
        break;
      }
    }

    // 无有效数据，直接返回
    if (firstPointIndex >= end) {
      return;
    }

    _linePath.reset();
    _linePath.moveTo(calculator.getXOffsetWithItem(firstPointIndex),
        calculator.getYOffset(indexLineData.data[firstPointIndex].y!));

    for (int i = firstPointIndex + 1; i < end; i++) {
      Entry entry = indexLineData.data[i];
      if (entry.x == null || entry.y == null) {
        continue;
      }

      _linePath.lineTo(calculator.getXOffsetWithItem(i), calculator.getYOffset(entry.y));
    }

    if (indexLineSpec.dashWidth != 0) {
      _dashPainter.draw(canvas, _linePath, _linePaint);
    } else {
      canvas.drawPath(_linePath, _linePaint);
    }
  }
}
