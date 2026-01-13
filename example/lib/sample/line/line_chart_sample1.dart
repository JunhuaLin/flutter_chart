import 'package:example/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';
import 'package:flutter_chart/flutter_chart.dart';
import 'package:intl/intl.dart';

/// FileName line_chart_example1
///
/// @Author junhua
/// @Date 2024/3/19
class _LineChartWidget extends StatelessWidget {
  final List<HistoryItem> items;

  const _LineChartWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(items),
      lineSpec: const LineSpec(
        lineColor: AppColors.contentColorBlue,
      ),
      height: 200.px,
      xAxisSpec: const AxisSpec(
        axisLineColor: AppColors.gridLinesColor,
        labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        showGirdLine: false,
        labelMargin: EdgeInsets.only(top: 10),
      ),
      yAxisSpec: const AxisSpec(
        showLabel: true,
        showGirdLine: false,
        axisLineColor: AppColors.gridLinesColor,
        labelTextStyle: TextStyle(color: AppColors.mainTextColor3, fontSize: 12),
        gridLineColor: Colors.purple,
        labelMargin: EdgeInsets.only(right: 10),
      ),
      yAxisValueProvider: AxisValueProvider(
        axisValueProvider: (dataSet, count, index) {
          List<double> doubleArray = List.filled(2, 0);
          doubleArray[0] = dataSet.minY.toDouble();
          doubleArray[1] = dataSet.maxY * 1.5;
          return doubleArray;
        },
        axisValueFormatter: (value, _, __) => value.toStringAsFixed(2),
      ),
      xAxisIndexProvider: AxisIndexProvider(
        axisIndexProvider: (dataSet, count, index) {
          return [index.toInt(), (index + count - 1).toInt()];
        },
        axisValueFormatter: (value, _, __) =>
            DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
      ),
      crossStitchSpec: const CrossStitchSpec(
        showStitchCircle: true,
      ),
      onCrossStitchMovingCallback: OnLongPressCallback(
        onLongPress: (value, index) {
          debugPrint("longPressCallback $value");
        },
      ),
    );
  }
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<LineChartSample1> createState() => _LineChartSample1State();
}

class _LineChartSample1State extends State<LineChartSample1> {
  late final List<HistoryItem> items;

  @override
  void initState() {
    super.initState();
    items = [
      HistoryItem(DateTime(2021, 8, 1), 1),
      HistoryItem(DateTime(2021, 8, 2), 2),
      HistoryItem(DateTime(2021, 8, 3), 3),
      HistoryItem(DateTime(2021, 8, 4), 4),
      HistoryItem(DateTime(2021, 8, 5), 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _LineChartWidget(items: items),
    );
  }
}

/// 历史走势数据
class HistoryItem extends Entry<double, double> {
  final DateTime date;
  final double value;

  HistoryItem(this.date, this.value) : super(date.millisecondsSinceEpoch.toDouble(), value);
}
