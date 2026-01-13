import 'package:example/util/app_helper.dart';
import 'package:flutter/cupertino.dart';

/// FileName chart_sample
///
/// @Author junhua
/// @Date 2024/3/18
/// chart图表的抽象类
abstract class ChartSample {
  final int number;
  final WidgetBuilder builder;

  ChartType get type;

  String get name => '${type.displayName} Sample $number';

  ChartSample(this.number, this.builder);
}

class LineChartSample extends ChartSample {
  LineChartSample(super.number, super.builder);

  @override
  ChartType get type => ChartType.line;
}

class BarChartSample extends ChartSample {
  BarChartSample(super.number, super.builder);

  @override
  ChartType get type => ChartType.bar;
}

class PieChartSample extends ChartSample {
  PieChartSample(super.number, super.builder);

  @override
  ChartType get type => ChartType.pie;
}

class CandleChartSample extends ChartSample {
  CandleChartSample(super.number, super.builder);

  @override
  ChartType get type => ChartType.candle;
}

class StockChartSample extends ChartSample {
  StockChartSample(super.number, super.builder);

  @override
  ChartType get type => ChartType.stock;
}
