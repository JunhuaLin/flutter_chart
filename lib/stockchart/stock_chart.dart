import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/behavior/behavior_callback.dart';
import 'package:flutter_chart/chart/core/base_chart.dart';
import 'package:flutter_chart/chart/core/chart_gesture_container.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/stockchart/multifunction_bar.dart';

/// FileName stock_chart
///
/// @Author junhua
/// @Date 2024/3/25
/// @Description 证券图表
class StockChart extends StatefulWidget {
  /// 加载更多回调
  final LoadMoreCallback? loadMoreCallback;

  /// 十字针回调
  final OnLongPressCallback? crossStitchCallback;

  const StockChart({super.key, this.loadMoreCallback, this.crossStitchCallback});

  @override
  State<StockChart> createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  /// 主图
  late BaseChart _mainChart;

  /// 副图
  late List<BaseChart> _subChartList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultChartGestureContainer(
      child: Stack(children: [
        const MultifunctionBarWidget(),
        Column(
          children: [
            _mainChart,
            ..._subChartList,
          ],
        ),
      ]),
    );
  }
}

/// 当K线滑动到第一个item时会触发此回调，上层可以再此回调里加载更多
typedef LoadMoreCallback = void Function(Entry fisrt);
