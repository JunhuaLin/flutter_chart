import 'package:example/resources/app_assets.dart';

/// FileName app_helper
///
/// @Author jingweixie
/// @Date 2024/3/18

/// 图表枚举类型
enum ChartType {
  stock,
  candle,
  line,
  bar,
  pie,
}

extension ChartTypeExtension on ChartType {
  /// 展示名称
  String get displayName => '$simpleName Chart';

  String get simpleName => switch (this) {
        ChartType.line => 'Line',
        ChartType.bar => 'Bar',
        ChartType.pie => 'Pie',
        ChartType.candle => 'Candle',
        ChartType.stock => 'Stock',
      };

  String get assetIcon => AppAssets.getChartIcon(this);
}
