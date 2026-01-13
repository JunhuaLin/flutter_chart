library flutter_chart;

import 'package:flutter_chart/chart/util/ui_utils.dart';

export 'chart/axis/axis_data_set.dart';

/// spec属性值设置
export 'chart/axis/axis_spec.dart';

/// 柱状图
export 'chart/bar/bar_chart.dart';
export 'chart/bar/bar_chart_data.dart';
export 'chart/bar/bar_entry.dart';
export 'chart/bar/bar_spec.dart';

/// 操作回调
export 'chart/behavior/behavior_callback.dart';
export 'chart/candle/candle_entry.dart';

/// 蜡烛图
export 'chart/candle/candle_stick_chart.dart';
export 'chart/candle/candle_stick_chart_data.dart';
export 'chart/candle/candle_stick_spec.dart';

/// 内容
export 'chart/content/index/index_draw_line_content.dart';
export 'chart/content/index/index_line_data.dart';
export 'chart/content/index/index_line_spec.dart';
export 'chart/core/chart_gesture_container.dart';
export 'chart/core/chart_gesture_manager.dart';
export 'chart/cross_stitch/cross_stitch_spec.dart';

/// 基础属性
export 'chart/data/data_set.dart';
export 'chart/data/entry.dart';

/// 横向柱状图
export 'chart/horizontal_bar/horizontal_bar_chart.dart';
export 'chart/horizontal_bar/horizontal_bar_spec.dart';

/// 折线图
export 'chart/line/line_chart.dart';
export 'chart/line/line_chart_data.dart';
export 'chart/line/line_spec.dart';

/// 饼图
export 'chart/pie/pie.dart';

/// 属性提供
export 'chart/provider/axis_value_provider.dart';
export 'chart/provider/item_margin_provider.dart';

/// tick图
export 'chart/tick/tick_chart.dart';
export 'chart/tick/tick_chart_spec.dart';
export 'chart/tick/tick_data_set.dart';
export 'chart/tick/tick_item_entry.dart';

/// 分时图
export 'chart/time_share/time_sharing_chart.dart';
export 'chart/time_share/time_sharing_dataset.dart';
export 'chart/time_share/time_sharing_entry.dart';
export 'chart/time_share/time_sharing_spec.dart';

/// 股票图表
export 'stockchart/data/kline_point.dart';
export 'stockchart/data/time_sharing_point.dart';

class FlutterChart {
  /// 使用前需要调用初始化方法
  static void initChart(
      {double textScaleFactor = 1, double Function(double size)? pxTransformFunc}) {
    UiUtils.textScaleFactor = textScaleFactor;
    UiUtils.pxTransformFunc = pxTransformFunc ?? (size) => size;
  }
}
