import 'dart:async';
import 'dart:math';

import 'package:example/data/time_sharing_data.dart';
import 'package:example/resources/app_colors.dart';
import 'package:example/resources/app_json.dart';
import 'package:example/util/data_util.dart';
import 'package:example/util/date_formate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName stock_chart_sample
///
/// @Author jingweixie
/// @Date 2024/3/22
/// @Description 分时图
class StockChartSample1 extends StatefulWidget {
  const StockChartSample1({super.key});

  @override
  State<StockChartSample1> createState() => _StockChartSample1State();
}

class _StockChartSample1State extends State<StockChartSample1> {
  TimeSharingDataSet _timeSharingChartData =
      TimeSharingDataSet(lastClosePrice: double.negativeInfinity, selections: []);

  /// 计时器
  Timer? timer;

  /// 用于进行推送数据的限制
  int pushIndex = 100;

  /// 推送点
  TimeSharingEntry? pushEntry;

  @override
  void initState() {
    super.initState();

    /// 初始化时读取数据
    DataUtil.getTimeSharingData(AppJson.timeSharingBili2).then((timeSharingDay) {
      if (!mounted) {
        return;
      }

      setState(() {
        final lastClosePrice = timeSharingDay.selectionList[0].lastClosePrice / pow(10, 9);
        final List<TimeSelection> showSelections = [];
        List<TimeSharingEntry> selectionList = [];
        int totalCount = 0;
        for (SectionList sectionList in timeSharingDay.selectionList) {
          double total = 0;
          double volume = 0;
          int begin = sectionList.selectionList[0].time;
          int end = sectionList.selectionList[sectionList.selectionList.length - 1].time;
          TimeSelection showSelection = TimeSelection(startTime: begin, endTime: end);

          for (TimeSharingPoint point in sectionList.selectionList) {
            total += point.close * point.volume;
            volume += point.volume;
            double avg = total / volume;
            var timeSharingEntry = TimeSharingEntry(
              time: point.time,
              close: point.close / pow(10, 9),
              average: avg / pow(10, 9),
              isBlank: point.isBlank,
            );

            /// 用于初始限制数据，后续的数据通过推送显示
            showSelection.addEntry(timeSharingEntry..isBlank = totalCount > pushIndex);
            selectionList.add(timeSharingEntry);
            totalCount++;
          }
          showSelections.add(showSelection);
        }

        _timeSharingChartData =
            TimeSharingDataSet(lastClosePrice: lastClosePrice, selections: showSelections)
              ..displayCount = totalCount.toDouble();
        timer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
          if (pushIndex >= selectionList.length || !mounted) {
            timer.cancel();
            return;
          }
          setState(() {
            var entry = selectionList[pushIndex++]..isBlank = false;
            _timeSharingChartData.updateEntry(
              entry,
            );
            pushEntry = entry;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: _timeSharingChartData.data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '分时图',
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
                        child: TimeSharingChart(
                          _timeSharingChartData,
                          pushEntry: pushEntry,
                          enableCrossStitch: true,
                          enablePushAnimation: true,
                          xAxisIndexProvider: AxisIndexProvider(
                            axisIndexProvider: (dataSet, count, startIndex) {
                              return [
                                startIndex.toInt(),
                                (startIndex + count / 2 - 15).toInt(),
                                min(
                                  (startIndex + count - 1).ceil(),
                                  dataSet.data.length - 1,
                                )
                              ];
                            },
                            axisValueFormatter: (value, _, __) {
                              if (value == _timeSharingChartData.data.first.x) {
                                // 第一个数据显示日期，后续数据显示时间
                                return DateFormatUtil.formatDateToDayMonthYearByValue(
                                  value.toInt(),
                                  formats: monthDay,
                                );
                              }
                              return DateFormatUtil.formatDateToDayMonthYearByValue(
                                value.toInt(),
                                formats: hourMinute,
                              );
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
                              return value.toStringAsFixed(2);
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
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
