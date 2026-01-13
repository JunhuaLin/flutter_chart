import 'dart:ui';

import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/bar/bar_chart_data.dart';
import 'package:flutter_chart/chart/bar/bar_entry.dart';
import 'package:flutter_chart/chart/bar/bar_spec.dart';

/// Description: 柱状图计算器
///
/// Author: jingweixie
/// Date: 2023-08-15 19:56:21
class BarCalculator extends XYComponentCalculator<BarEntry> {
  BarSpec barSpec;

  BarChartData barDataSet;

  BarCalculator(
    this.barDataSet,
    AxisContextCalculator axisContext, {
    required this.barSpec,
  }) : super(barDataSet, axisContext);

  Rect getDrawBarRect(int index) {
    double leftPos = getXOffset(index);
    double rightPos = leftPos + itemWidth;

    BarEntry entry = barDataSet.data[index];

    double topPos = getYOffset(barSpec.barDataProvider.getMaxValue(entry));
    double bottomPos = getYOffset(barSpec.barDataProvider.getMinValue(entry));

    return Rect.fromLTRB(leftPos, topPos, rightPos, bottomPos);
  }
}
