import 'dart:math';

import 'package:example/resources/app_colors.dart';
import 'package:example/resources/app_json.dart';
import 'package:example/sample/candle/common_candle_chart.dart';
import 'package:example/util/data_util.dart';
import 'package:example/util/date_formate.dart';
import 'package:example/util/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bar/bar_data_provider.dart';
import 'package:flutter_chart/flutter_chart.dart';
import 'package:oktoast/oktoast.dart';

/// FileName candle_sample2
///
/// @Author junhua
/// @Date 2024/3/25
/// @Description 蜡烛图表,包含主图和副图
class CandleChartSample2 extends StatefulWidget {
  const CandleChartSample2({super.key});

  @override
  State<CandleChartSample2> createState() => _CandleChartSample2State();
}

class _CandleChartSample2State extends State<CandleChartSample2> {
  CandleStickChartData _candleStickChartData = CandleStickChartData(const []);

  final double _displayCount = 30;

  /// 切换蜡烛图和折线图之前的显示个数
  final double _displayCountLimit = 35;

  static const double _itemMargin = 3;

  /// 有更多数据
  bool _hasMore = true;

  bool _showCandle = true;

  ItemMarginProvider itemMarginProvider = ItemMarginProvider(
    (displayCount, contentWidth) {
      double itemMargin = (contentWidth / displayCount) / 5;
      if (itemMargin < _itemMargin) {
        return _itemMargin;
      }
      return itemMargin;
    },
  );

  static const double _maxItemWidth = 30;
  static const double _minItemWidth = 1;

  @override
  void initState() {
    super.initState();

    /// 初始化时读取数据
    DataUtil.getCandleData(AppJson.dailyKLineBili1).then((value) => setState(() {
          _candleStickChartData = CandleStickChartData(value)
            ..displayCount = _displayCount
            ..startIndex = value.length - 2 * _displayCount;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.5,
      child: _candleStickChartData.data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : DefaultChartGestureContainer(
              child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'k线图',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _showCandle
                        ? CommonCandleChart(
                            _candleStickChartData,
                            itemMarginProvider: itemMarginProvider,
                            isGreenHollow: true,
                            itemMargin: _itemMargin,
                            xAxisValueFormatter: (value, _, __) {
                              return DateFormatUtil.formatDateToDayMonthYearByValue(value.toInt());
                            },
                            yAxisValueFormatter: (value, _, __) {
                              return (value / 1000000000).toStringAsFixed(2);
                            },
                            loadMoreCallback: (first) {
                              if (_hasMore) {
                                DataUtil.getCandleData(AppJson.dailyKLineBili2).then((value) {
                                  showToast("成功加载数据");
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _candleStickChartData.insertData(value, isEnd: false);
                                    });
                                    _hasMore = false;
                                  }
                                });
                              }
                            },
                            displayCountChangeCallBack: (displayCount) {
                              if (displayCount > _displayCountLimit) {
                                setState(() {
                                  _showCandle = false;
                                });
                              }
                            },
                            maxItemWidth: _maxItemWidth,
                            minItemWidth: _minItemWidth,
                          )
                        : LineChart(
                            _candleStickChartData,
                            itemMarginProvider: itemMarginProvider,
                            enableMove: true,
                            enableCrossStitch: true,
                            enableScale: true,
                            onScaleCallback: (_, __, displayCount, ___) {
                              if (displayCount < _displayCountLimit) {
                                setState(() {
                                  _showCandle = true;
                                });
                              }
                            },
                            lineSpec: const LineSpec(
                              lineWidth: 1,
                              showShader: false,
                            ),
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
                              axisValueFormatter: (value, _, __) {
                                return DateFormatUtil.formatDateToDayMonthYearByValue(
                                    value.toInt());
                              },
                            ),
                            yAxisValueProvider: AxisValueProvider(
                              axisValueProvider: (dataSet, count, startIndex) {
                                List<double> doubleArray = List.filled(2, 0);
                                doubleArray[0] = dataSet.minY * 0.9;
                                doubleArray[1] = dataSet.maxY * 1.1;
                                return doubleArray;
                              },
                              axisValueFormatter: (value, _, __) {
                                return (value / 1000000000).toStringAsFixed(2);
                              },
                            ),
                            yAxisSpec: const AxisSpec(
                              showGirdLine: false,
                              axisLineColor: AppColors.gridLinesColor,
                              labelTextStyle:
                                  TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
                              labelMargin: EdgeInsets.only(left: 3),
                              drawInner: true,
                            ),
                            xAxisSpec: const AxisSpec(
                              itemMargin: _itemMargin,
                              showGirdLine: false,
                              axisLineColor: AppColors.gridLinesColor,
                              labelTextStyle:
                                  TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
                              maxItemWidth: _maxItemWidth,
                              minItemWidth: _minItemWidth,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "成交额",
                      style: TextStyle(color: AppColors.contentColorCyanWithOpacity, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _VolumeChart(
                      itemMargin: _itemMargin,
                      itemMarginProvider: itemMarginProvider,
                      dataList: _candleStickChartData,
                      maxItemWidth: _maxItemWidth,
                      minItemWidth: _minItemWidth,
                    ),
                  ),
                )
              ],
            )),
    );
  }
}

/// 成交量chart
class _VolumeChart extends StatelessWidget {
  final double itemMargin;
  final CandleStickChartData dataList;
  final double maxItemWidth;
  final double minItemWidth;
  final ItemMarginProvider? itemMarginProvider;

  const _VolumeChart({
    super.key,
    required this.itemMargin,
    required this.dataList,
    required this.maxItemWidth,
    required this.minItemWidth,
    required this.itemMarginProvider,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      dataList,
      itemMarginProvider: itemMarginProvider,
      enableMove: true,
      enableCrossStitch: true,
      enableScale: true,
      barSpec: BarSpec(
        lineWidth: 2,
        barDataProvider: _VolumeDataProvider(),
        colorProvider: (data, index) =>
            dataList.data[index].open > dataList.data[index].close ? Colors.red : Colors.green,
      ),
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
        axisValueFormatter: (value, _, __) {
          return DateFormatUtil.formatDateToDayMonthYearByValue(value.toInt());
        },
      ),
      yAxisValueProvider: AxisValueProvider(
        axisValueProvider: (dataSet, count, startIndex) {
          List<double> doubleArray = List.filled(2, 0);
          doubleArray[0] = 0;
          doubleArray[1] = _getVolumeMaxValue(
                  startIndex.toInt(),
                  min(
                    (startIndex + count - 1).ceil(),
                    dataSet.data.length - 1,
                  )) *
              1.1;
          return doubleArray;
        },
        axisValueFormatter: (value, _, __) {
          return NumUtils.formatWithUnit(value / 1000);
        },
      ),
      yAxisSpec: const AxisSpec(
        showGirdLine: false,
        axisLineColor: AppColors.gridLinesColor,
        labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        labelMargin: EdgeInsets.only(left: 3),
        showLabel: false,
        drawInner: true,
      ),
      xAxisSpec: AxisSpec(
        itemMargin: itemMargin,
        maxItemWidth: maxItemWidth,
        minItemWidth: minItemWidth,
        showGirdLine: false,
        axisLineColor: AppColors.gridLinesColor,
        labelTextStyle: const TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
      ),
      crossStitchSpec: const CrossStitchSpec(),
    );
  }

  double _getVolumeMaxValue(int begin, int end) {
    double maxValue = double.negativeInfinity;
    for (int i = begin; i < end; i++) {
      maxValue = max(maxValue, dataList.data[i].volume);
    }

    return maxValue;
  }
}

class _VolumeDataProvider extends IBarDataProvider<CandleEntry> {
  @override
  double getMaxValue(CandleEntry entry) {
    return entry.volume;
  }

  @override
  double getMinValue(CandleEntry entry) {
    return 0;
  }
}
