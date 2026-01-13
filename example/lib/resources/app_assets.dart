import 'package:example/util/app_helper.dart';

/// FileName app_assets
///
/// @Author junhua
/// @Date 2024/3/18
/// app icon资源
class AppAssets {
  static String getChartIcon(ChartType type) {
    switch (type) {
      case ChartType.line:
        return 'assets/icons/ic_line_chart.svg';
      case ChartType.bar:
        return 'assets/icons/ic_bar_chart.svg';
      case ChartType.pie:
        return 'assets/icons/ic_pie_chart.svg';
      case ChartType.candle:
        return 'assets/icons/ic_candle_chart.svg';
      case ChartType.stock:
        return 'assets/icons/ic_stock_chart.svg';
    }
  }

  static const flChartLogoIcon = 'assets/icons/fl_chart_logo_icon.png';
  static const flChartLogoText = 'assets/icons/fl_chart_logo_text.svg';
  static const flChartPerformance = 'assets/icons/ic_performance.svg';
  static const flChartReset = 'assets/icons/ic_reset.svg';
}
