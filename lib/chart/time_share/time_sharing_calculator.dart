import 'dart:ui';

import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_dataset.dart';
import 'package:flutter_chart/chart/time_share/time_sharing_entry.dart';

/// FileName time_sharing_calculator
///
/// @Author junhua
/// @Date 2024/4/1
class TimeSharingCalculator extends XYComponentCalculator<TimeSharingEntry> {
  /// 分时数据集
  TimeSharingDataSet timeSharingDataSet;

  /// 是否显示现价线
  bool showAvgLine;

  /// 上一个收盘价
  double get lastClosePrice => timeSharingDataSet.lastClosePrice;

  /// 分时的数据
  List<TimeSelection> get selections => timeSharingDataSet.selections;

  TimeSharingCalculator(
    this.timeSharingDataSet,
    AxisContextCalculator axisContext, {
    this.showAvgLine = true,
  }) : super(
          timeSharingDataSet,
          axisContext,
        );

  /// 获取收盘价在Y轴上的位置
  double getLastClosePriceYPos() {
    return axisContext.getYOffsetByDataValue(lastClosePrice);
  }

  ({List<Path> item1, List<Path> item2, List<Path> item3}) getDrawPath(
    double startIndex,
    double displayCount,
  ) {
    var selections = timeSharingDataSet.selections;
    List<Path> pricePathList = [];
    List<Path> shaderPathList = [];
    List<Path> avgPathList = [];
    if (selections.isNotEmpty) {
      int offsetIndex = 0;
      for (TimeSelection selection in selections) {
        if (selection.hasValidEntry) {
          if (_selectionInRange(selection, startIndex, displayCount, offsetIndex)) {
            Path pricePath = Path();
            Path shaderPath = Path();

            /// 构建价格线和阴影路径
            var entryList = selections.expand((element) => element.entries).toList();
            buildLinePath(
              pricePath,
              shaderPath,
              startIndex,
              displayCount,
              entryList,
              (entry, index) => entry.isValid ? entry.close : double.negativeInfinity,
            );

            pricePathList.add(pricePath);
            shaderPathList.add(shaderPath);

            if (showAvgLine) {
              Path avgPath = Path();
              buildLinePath(
                avgPath,
                null,
                startIndex,
                displayCount,
                entryList,
                (entry, index) => entry.isValid ? entry.average : double.negativeInfinity,
              );
              avgPathList.add(avgPath);
            }
          } else {
            pricePathList.add(Path());
            shaderPathList.add(Path());
          }
        }

        offsetIndex += selection.entryCount;
      }
    }
    return (item1: pricePathList, item2: shaderPathList, item3: avgPathList);
  }

  /// 判断selection的数据是否在当前显示的数据范围内
  bool _selectionInRange(
    TimeSelection selection,
    double startIndex,
    double displayCount,
    int offsetIndex,
  ) {
    final entryStartIndexInData = offsetIndex;
    final entryEndIndexInData = selection.entryCount + offsetIndex;

    final dataStartIndex = startIndex;
    final dataEndIndex = startIndex + displayCount;

    return (dataStartIndex < entryStartIndexInData &&
            dataEndIndex > entryEndIndexInData) // 1.分时显示数据包裹entry数据
        ||
        (dataStartIndex > entryStartIndexInData &&
            dataEndIndex < entryEndIndexInData) // 2.entry数据包裹分时显示数据
        ||
        (dataStartIndex < entryEndIndexInData && dataEndIndex > entryEndIndexInData) //交叉
        ||
        (dataStartIndex < entryStartIndexInData && dataEndIndex > entryStartIndexInData) //交叉
        ||
        dataStartIndex == entryStartIndexInData ||
        dataStartIndex == entryEndIndexInData ||
        dataEndIndex == entryStartIndexInData ||
        dataEndIndex == entryEndIndexInData;
  }
}
