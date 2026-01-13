import 'dart:math';

import 'package:example/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName lne_chart_sample2
///
/// @Author jingweixie
/// @Date 2024/3/20
class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  LineChartSample2State createState() => LineChartSample2State();
}

class LineChartSample2State extends State<LineChartSample2> {
  late LineChartData dataSet;

  /// 初始加载数据开始的index
  final int _initialStartIndex = 300;

  /// 每次加载的数目
  final int _count = 100;

  /// 最大可加载的数目
  final int _maxCount = 600;

  @override
  void initState() {
    super.initState();
    _initDataSet();
  }

  void _initDataSet() {
    dataSet = LineChartData(getRandomData(_initialStartIndex, _count))
      ..startIndex = _count / 2
      ..displayCount = _count / 2;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.23,
        child: Stack(
          children: [
            Column(children: [
              const SizedBox(
                height: 37,
              ),
              const Text(
                'Interaction chart',
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
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(
                    data: dataSet,
                    loadMoreCallBack: (isEnd) {
                      setState(() {
                        if (isEnd) {
                          if (dataSet.data.length <= _maxCount) {
                            dataSet.insertData(getRandomData(
                              dataSet.data.length,
                              _count,
                            ));
                          }
                        } else {
                          if (dataSet.data[0].x >= _count) {
                            var start = dataSet.data[0].x - _count;
                            dataSet.insertData(
                              getRandomData(start.toInt(), _count),
                              isEnd: false,
                            );
                          }
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
            IconButton(
                onPressed: () {
                  setState(() {
                    _initDataSet();
                  });
                },
                icon: const Icon(
                  Icons.refresh,
                )),
          ],
        ));
  }

  List<Entry<double, double>> getRandomData(int start, int count) {
    List<Entry<double, double>> dataSet = [];
    var random = Random();
    for (int i = start; i < (start + count); i++) {
      var entry = Entry(i.toDouble(), random.nextInt(100).toDouble());
      dataSet.add(entry);
    }
    return dataSet;
  }
}

Widget _LineChart({
  required LineChartData data,
  LoadMoreCallBack? loadMoreCallBack,
  Key? key,
}) {
  return DefaultChartGestureContainer(
    child: LineChart(
      key: key,
      data,
      showHighAndLowLabel: true,
      enableMove: true,
      enableScale: true,
      enableCrossStitch: true,
      lineSpec: LineSpec(
        lineWidth: 1.px,
      ),
      yAxisValueProvider: AxisValueProvider(
        axisValueProvider: (dataSet, count, index) {
          List<double> doubleArray = List.filled(2, 0);
          doubleArray[0] = dataSet.minY.toDouble();
          doubleArray[1] = dataSet.maxY * 1.5;
          return doubleArray;
        },
      ),
      xAxisSpec: const AxisSpec(
        axisLineColor: AppColors.gridLinesColor,
        labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        gridLineColor: Colors.purple,
        showGirdLine: true,
      ),
      xAxisIndexProvider: AxisIndexProvider(
        axisIndexProvider: (dataSet, count, startIndex) {
          List<int> intArray = List.filled(3, 0);
          intArray[0] = startIndex.toInt();
          intArray[1] = (startIndex + count / 2 - 1).toInt();
          intArray[2] = (startIndex + count - 1).toInt();
          return intArray;
        },
      ),
      yAxisSpec: const AxisSpec(
        showLabel: true,
        axisLineColor: AppColors.gridLinesColor,
        labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        gridLineColor: Colors.purple,
        showGirdLine: false,
      ),
      crossStitchSpec: const CrossStitchSpec(
        showStitchCircle: true,
      ),
      onCrossStitchMovingCallback: OnLongPressCallback(
        onLongPress: (value, index) {},
      ),
      onMoveCallback: (oldStartIndex, newStartIndex, displayCount, totalCount) {
        if (loadMoreCallBack != null) {
          /// 到最后一个数据时，开始加载更多
          if (newStartIndex + displayCount >= totalCount - 1) {
            loadMoreCallBack(true);
          }

          /// 移动到第一个数据时，加载更多
          if (newStartIndex <= 1) {
            loadMoreCallBack(false);
          }
        }
      },
    ),
  );
}

/// 加载更多回调，isEnd表示是否已经到底
typedef LoadMoreCallBack = void Function(bool isEnd);
