import 'dart:math';

import 'package:example/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName common_candle_chart
///
/// @Author junhua
/// @Date 2024/3/25
/// @Description 通用的蜡烛图图表
class CommonCandleChart extends StatelessWidget {
  final CandleStickChartData stickChartData;
  final double itemMargin;
  final StringProvider? xAxisValueFormatter;
  final StringProvider? yAxisValueFormatter;
  final LoadMoreCallback? loadMoreCallback;
  final bool? isRedHollow;
  final bool? isGreenHollow;
  final OnLongPressCallback? onLongPressCallback;
  final DisplayCountChangeCallBack? displayCountChangeCallBack;
  final double maxItemWidth;
  final double minItemWidth;
  final ItemMarginProvider? itemMarginProvider;

  const CommonCandleChart(
    this.stickChartData, {
    Key? key,
    this.itemMargin = 5,
    this.xAxisValueFormatter,
    this.yAxisValueFormatter,
    this.loadMoreCallback,
    this.isGreenHollow = false,
    this.isRedHollow = false,
    this.onLongPressCallback,
    this.displayCountChangeCallBack,
    this.maxItemWidth = 20,
    this.minItemWidth = 5,
    this.itemMarginProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var axisSpec = AxisSpec(
      itemMargin: itemMargin,
      showGirdLine: false,
      maxItemWidth: maxItemWidth,
      minItemWidth: minItemWidth,
      axisLineColor: AppColors.gridLinesColor,
      labelTextStyle: const TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
      gridLineColor: Colors.purple,
    );
    return CandleStickChart(
      stickChartData,
      itemMarginProvider: itemMarginProvider,
      enableMove: true,
      enableScale: true,
      contentRenderList: [
        IndexDrawLineContent(
          _buildMA5ChartData(
            stickChartData,
          ),
          indexLineSpec: const IndexLineSpec(dashWidth: 2, dashSpan: 1),
        ),
      ],
      yAxisValueProvider: AxisValueProvider(
        axisValueProvider: (dataSet, count, index) {
          List<double> doubleArray = List.filled(2, 0);
          doubleArray[0] = dataSet.minY * 0.8;
          doubleArray[1] = dataSet.maxY * 1.1;

          return doubleArray;
        },
        axisValueFormatter: yAxisValueFormatter,
      ),
      xAxisSpec: axisSpec,
      xAxisIndexProvider: AxisIndexProvider(
        axisIndexProvider: (dataSet, count, startIndex) {
          return [
            startIndex.toInt(),
            min(
              (startIndex + count - 1).ceil(),
              dataSet.data.length - 1,
            )
          ];
        },
        axisValueFormatter: xAxisValueFormatter,
      ),
      yAxisSpec: const AxisSpec(
        showLabel: true,
        showGirdLine: false,
        axisLineColor: AppColors.gridLinesColor,
        labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        gridLineColor: Colors.purple,
        drawInner: true,
        labelMargin: EdgeInsets.only(right: 10),
      ),
      candleStickSpec: CandleStickSpec(
        showHighLowPriceLabel: true,
        greenCandleHollow: isGreenHollow!,
        redCandleHollow: isRedHollow!,
        labelTextStyle: const TextStyle(
          fontSize: 8,
          color: AppColors.mainTextColor2,
        ),
        candleColorProvider: (index) {
          return stickChartData.data[index].open > stickChartData.data[index].close
              ? CandleColor.red
              : CandleColor.green;
        },
      ),
      enableCrossStitch: true,
      crossStitchSpec: const CrossStitchSpec(
        stitchLineColor: AppColors.contentColorBlue,
        stitchLineWidth: 1,
        labelBackGroundColor: AppColors.contentColorCyanWithOpacity,
        labelTextStyle: TextStyle(
          fontSize: 12,
          color: AppColors.mainTextColor2,
        ),
      ),
      onMoveCallback: (oldStartIndex, newStartIndex, displayCount, _) {
        /// 移动到第一个item时，触发加载
        if (newStartIndex < 1) {
          loadMoreCallback?.call(stickChartData.data.first);
        }
      },
      onCrossStitchMovingCallback: onLongPressCallback,
      onScaleCallback: (oldStartIndex, newStartIndex, displayCount, _) {
        displayCountChangeCallBack?.call(displayCount);
      },
      candleValueProvider: (value) {
        return yAxisValueFormatter?.call(value, 0, 0) ?? value.toStringAsFixed(2);
      },
    );
  }

  IndexLineData _buildMA5ChartData(CandleStickChartData data) {
    List<Entry<double?, double?>> ma5Data = [];
    for (int i = 0; i < data.data.length; i++) {
      if (i < 5 || !data.data[i].isValid) {
        ma5Data.add(Entry(null, null));
      } else {
        double sum = 0;
        for (int j = i - 5; j < i; j++) {
          sum += data.data[j].close;
        }
        ma5Data.add(Entry(data.data[i].x, sum / 5));
      }
    }
    return IndexLineData(ma5Data);
  }
}

/// 当K线滑动到第一个item时会触发此回调，上层可以再此回调里加载更多
typedef LoadMoreCallback = void Function(Entry fisrt);

typedef DisplayCountChangeCallBack = void Function(double displayCount);
