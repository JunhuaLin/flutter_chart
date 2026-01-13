import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_calculator.dart';
import 'package:flutter_chart/chart/data/entry.dart';

/// @Description x轴的计算，主要为坐标值和显示的文本
///
/// @Author junhua
/// @Date 2023/8/2
class XAxisCalculator extends AxisCalculator {
  @override
  double get dataMax => axisDataSet.maxX.toDouble();

  @override
  double get dataMin => axisDataSet.minX.toDouble();

  double get axisTextTopMargin => axisSpec.labelMargin.top;

  /// 用于计算index之间的偏移量
  static const double _indexOffset = 0.5;

  XAxisCalculator(
    super.axisDataSet,
    super.axisContext, {
    required super.axisSpec,
    required super.axisIndexProvider,
    required super.axisValueProvider,
  });

  /// 获取坐标轴标签的高度
  double _getAxisLabelHeight() {
    if (axisEntrySet.isEmpty) return 0;
    return getTextHeight(
      getTextByDataIndex(axisEntrySet[0].toInt()),
      labelTextStyle,
    );
  }

  /// 获取最近一个有效的index
  int _indexOfNearestNotBlankEntry(int index) {
    var dataList = dataSet.data;
    if (dataList.isEmpty) {
      return -1;
    }

    if (index < 0 || index >= dataList.length) {
      return -1;
    }

    int lowIndex = -1;
    int highIndex = -1;
    for (int j = index - 1; j >= 0; j--) {
      Entry entry = dataList[j];
      if (entry.isValid) {
        lowIndex = j;
        break;
      }
    }

    for (int j = index + 1; j < dataList.length - 1; j++) {
      Entry entry = dataList[j];
      if (entry.isValid) {
        highIndex = j;
        break;
      }
    }

    if (lowIndex == highIndex) {
      return -1;
    }

    if (-1 == lowIndex) {
      return highIndex;
    }

    if (-1 == highIndex) {
      return lowIndex;
    }

    return highIndex - index > index - lowIndex ? lowIndex : highIndex;
  }

  /// 二分法根据value获取index
  int indexOfDataValue(double xValue) {
    var data = axisDataSet.data;
    if (data.isEmpty) {
      return -1;
    }

    int low = 0;
    int high = data.length - 1;

    while (low <= high) {
      int mid = (low + high) >>> 1;
      double midEntry = data[mid].x;
      int cmp = midEntry.compareTo(xValue);

      if (cmp < 0) {
        low = mid + 1;
      } else if (cmp > 0) {
        high = mid - 1;
      } else {
        return mid; // key found
      }
    }
    return -1; // key not found
  }

  /// 获取长按时index值
  int getIndexOfOnHold(double contentX, double startIndex) {
    int index;
    double avgItemWidthWithMargin = axisLength / displayCount;
    double tempIndex = contentX / avgItemWidthWithMargin + _indexOffset;
    tempIndex = (tempIndex >= displayCount) ? displayCount - 1 : tempIndex - 1;
    index = (max(tempIndex, 0) + startIndex).round();

    Entry entry = dataSet.data[index];
    if (!entry.isValid) {
      // 获取最近一个不是空点的index
      index = _indexOfNearestNotBlankEntry(index);
    }

    return index;
  }

  /// 计算x轴文本和轴线的高度
  double getBottomOffset() {
    // 计算的是文本 + 坐标轴线占据的大小
    var offsetLabel = axisSpec.showLabel
        ? _getAxisLabelHeight() + axisSpec.labelMargin.top + axisSpec.labelMargin.bottom
        : 0;
    double offsetLine = axisSpec.showAxisLine ? axisSpec.axisLineWidth : 0;
    return offsetLabel + offsetLine;
  }

  /// 计算x轴的偏移量
  @override
  double calAxisOffset(double index, entryValue) {
    return index * (itemWidth + itemMargin) + (0.5 * itemMargin);
  }

  /// 计算文本偏移量
  @override
  Offset getTextOffset(
    String text,
    TextStyle style,
    double drawAxisWidth,
    double drawAxisHeight,
    double startX,
    double xOffset,
    double yOffset,
    EdgeInsets margin,
  ) {
    if (text.isEmpty) return const Offset(0, 0);

    var textWidth = getTextWidth(text, style);
    // 文字居中显示
    var drawXOffset = xOffset - textWidth / 2 + margin.left;
    var drawYOffset = yOffset + margin.top;

    if (!labelCanExceedAxisLine) {
      if (drawXOffset < startX) {
        drawXOffset = startX;
      } else if (drawXOffset + textWidth > drawAxisWidth) {
        drawXOffset = drawAxisWidth - textWidth;
      }
    }

    return Offset(drawXOffset, drawYOffset);
  }

  @override
  List<double> indexToValue(List<int> indexList) {
    return indexList.map((index) => axisDataSet.data[index].x).toList();
  }
}
