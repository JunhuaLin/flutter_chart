import 'package:example/sample/bar/bar_chart_sample1.dart';
import 'package:example/sample/bar/bar_chart_sample2.dart';
import 'package:example/sample/candle/candle_chart_sample1.dart';
import 'package:example/sample/candle/candle_chart_sample2.dart';
import 'package:example/sample/chart_sample.dart';
import 'package:example/sample/line/line_chart_sample1.dart';
import 'package:example/sample/line/line_chart_sample2.dart';
import 'package:example/sample/pie/pie_chart_sample1.dart';
import 'package:example/sample/pie/pie_chart_sample2.dart';
import 'package:example/sample/stock/stock_chart_sample1.dart';
import 'package:example/sample/stock/stock_chart_sample2.dart';
import 'package:example/util/app_helper.dart';

/// FileName chart_samples
///
/// @Author junhua
/// @Date 2024/3/18
/// chart的显示样式
class ChartSamples {
  static final Map<ChartType, List<ChartSample>> samples = {
    ChartType.line: [
      LineChartSample(1, (context) => const LineChartSample1()),
      LineChartSample(2, (context) => const LineChartSample2()),
    ],
    ChartType.bar: [
      BarChartSample(1, (context) => const BarChartSample1()),
      BarChartSample(2, (context) => const BarChartSample2()),
    ],
    ChartType.pie: [
      PieChartSample(1, (context) => const PieChartSample1()),
      PieChartSample(2, (context) => const PieChartSample2()),
    ],
    ChartType.candle: [
      CandleChartSample(1, (context) => const CandleChartSample1()),
      CandleChartSample(2, (context) => const CandleChartSample2()),
    ],
    ChartType.stock: [
      StockChartSample(1, (context) => const StockChartSample1()),
      StockChartSample(2, (context) => const StockChartSample2()),
      CandleChartSample(2, (context) => const CandleChartSample2()),
    ],
  };
}
