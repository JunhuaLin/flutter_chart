import 'dart:math';

import 'package:example/resources/app_colors.dart';
import 'package:example/util/data_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName bar_chart_example2
///
/// @Author junhua
/// @Date 2024/3/21
class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({super.key});

  @override
  State<BarChartSample2> createState() => _BarChartSample2State();
}

class _BarChartSample2State extends State<BarChartSample2> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _BarChart(DataUtil.getRandomData()),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<BarEntry> dataList;

  const _BarChart(
    this.dataList, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultChartGestureContainer(
      child: BarChart(
        BarChartData(dataList)..displayCount = 50,
        enableCrossStitch: true,
        enableMove: true,
        enableScale: true,
        barSpec: BarSpec(
          colorProvider: (data, index) =>
              dataList[index].y > 500 ? AppColors.primary : AppColors.contentColorBlue,
        ),
        xAxisIndexProvider: AxisIndexProvider(
          axisIndexProvider: (dataSet, count, startIndex) {
            return [startIndex.toInt(), (startIndex + count - 1).toInt()];
          },
        ),
        yAxisValueProvider: AxisValueProvider(
          axisValueProvider: (dataSet, count, index) {
            var maxValue = max(dataSet.maxY.abs(), dataSet.minY.abs()) * 1.2;
            List<double> doubleArray = List.filled(2, 0);
            doubleArray[0] = 0;
            doubleArray[1] = maxValue;
            return doubleArray;
          },
        ),
        yAxisSpec: const AxisSpec(
          showGirdLine: false,
          axisLineColor: AppColors.gridLinesColor,
          labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        ),
        xAxisSpec: const AxisSpec(
          itemMargin: 2.5,
          showGirdLine: false,
          axisLineColor: AppColors.gridLinesColor,
          labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        ),
        crossStitchSpec: const CrossStitchSpec(),
      ),
    );
  }
}
