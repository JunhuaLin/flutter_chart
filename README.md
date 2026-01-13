<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## Features

用于基金中图表的显示


## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
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
      crossStitchMovingCallback: OnLongPressCallback(
        longPress: (value, index) {
          debugPrint("longPressCallback $value");
        },
      ),
    );
  }
}
```


