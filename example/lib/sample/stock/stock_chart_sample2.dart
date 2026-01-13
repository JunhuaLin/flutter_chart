import 'dart:math';

import 'package:example/resources/app_colors.dart';
import 'package:example/resources/app_json.dart';
import 'package:example/util/data_util.dart';
import 'package:example/util/date_formate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/content/high_low_label/high_and_low_label_spec.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName stock_chart_sample
///
/// @Author jingweixie
/// @Date 2024/3/22
/// @Description Tick图
class StockChartSample2 extends StatefulWidget {
  const StockChartSample2({super.key});

  @override
  State<StockChartSample2> createState() => _StockChartSample1State();
}

class _StockChartSample1State extends State<StockChartSample2> {
  TickDataset _tickChartData = TickDataset([]);

  final int _startIndex = 530;

  @override
  void initState() {
    super.initState();

    /// 初始化时读取数据
    DataUtil.getTickData(AppJson.tickData).then((value) => {
          setState(() {
            int totalCount = value.length;
            _tickChartData = TickDataset(value.reversed.toList())
              ..startIndex = _startIndex.toDouble()
              ..displayCount = (totalCount - _startIndex).toDouble();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: _tickChartData.data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Tick图',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultChartGestureContainer(
                        child: TickChart(
                          _tickChartData,
                          enableMove: true,
                          enableCrossStitch: true,
                          enablePushAnimation: true,
                          xAxisIndexProvider: AxisIndexProvider(
                            axisIndexProvider: (dataSet, count, startIndex) {
                              return [
                                startIndex.toInt(),
                                (startIndex + count / 2).toInt(),
                                min(
                                  (startIndex + count - 1).ceil(),
                                  dataSet.data.length - 1,
                                )
                              ];
                            },
                            axisValueFormatter: (value, _, __) {
                              return DateFormatUtil.formatDateToDayMonthYearByValue(
                                value.toInt(),
                                valueRadio: 1,
                                formats: hourMinuteSecond,
                              );
                            },
                          ),
                          yAxisValueProvider: AxisValueProvider(
                            axisValueProvider: (dataSet, count, startIndex) {
                              List<double> doubleArray = List.filled(2, 0);
                              doubleArray[0] = dataSet.minY - 0.04 * pow(10, 9);
                              doubleArray[1] = dataSet.maxY + 0.04 * pow(10, 9);
                              return doubleArray;
                            },
                            axisValueFormatter: (value, _, __) {
                              return (value / pow(10, 9)).toStringAsFixed(2);
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
                            showGirdLine: false,
                            axisLineColor: AppColors.gridLinesColor,
                            labelTextStyle:
                                TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
                          ),
                          crossStitchSpec: const CrossStitchSpec(
                            stitchOuterCircle: 2.5,
                            stitchLineWidth: 0.5,
                          ),
                          highAndLowLabelSpec: HighAndLowLabelSpec(
                              labelFormatter: (value, _, __) =>
                                  (value / pow(10, 9)).toStringAsFixed(2)),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
