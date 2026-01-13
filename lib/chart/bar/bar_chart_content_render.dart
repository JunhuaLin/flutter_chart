import 'dart:ui';

import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/bar/bar_calculator.dart';
import 'package:flutter_chart/chart/bar/bar_spec.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';

/// @Description 柱状图的render
///
/// @Author junhua
/// @Date 2023/8/16
class BarChartContentRender extends XYChartContentRender<BarCalculator> {
  /// 绘制折线的特性
  BarSpec barSpec;

  /// 绘制折线的画笔
  Paint barPaint;

  /// 用于判断柱状图是否小于特定高度
  final double _minHeight = 3.px;

  BarChartContentRender(super.calculator, {required this.barSpec, super.level})
      : barPaint = Paint()
          ..strokeWidth = barSpec.lineWidth
          ..style = PaintingStyle.fill
          ..color = barSpec.barColor;

  @override
  void drawContent(
    Canvas canvas,
    BarCalculator calculator,
    double width,
    double height,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    {
      List<Entry<double, double>> barEntryList = calculator.entryList;
      for (int i = begin; i < end; i++) {
        var entry = barEntryList[i];

        if (!entry.isValid) {
          continue;
        }

        Rect rect = calculator.getDrawBarRect(i);
        Rect barRect;

        // 如果矩形的top和bottom的差值小于3个像素
        // 就把top和bottom设置成一样的值(top和bottom的中间值)
        // 不然绘制出来的矩形非常细很难看清
        double diff = (rect.top - rect.bottom).abs();

        if (diff < _minHeight) {
          double yTop = (rect.bottom + rect.top) / 2;
          double yBottom = rect.top;
          // 矩形的top和bottom一样时 如果PaintStyle设置成FILL是绘制不图案的
          // 而设置成STROKE，是能够绘制成一条线的
          barPaint.style = PaintingStyle.stroke;
          barRect = Rect.fromLTRB(
            rect.left,
            (yTop > yBottom ? yBottom : yTop),
            rect.right,
            (yBottom > yTop ? yBottom : yTop),
          );
        } else {
          barPaint.style = PaintingStyle.fill;
          barRect = rect;
        }

        // 设置bar的颜色
        Color barColor = barSpec.colorProvider?.call(entry.y, i.toInt()) ?? barSpec.barColor;
        barPaint.color = barColor;

        canvas.drawRect(barRect, barPaint);
      }
    }
  }
}
