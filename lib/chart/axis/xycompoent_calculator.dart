import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/common/IValueProvider.dart';
import 'package:flutter_chart/chart/core/base_chart_calculator.dart';
import 'package:flutter_chart/chart/data/entry.dart';

/// FileName xycompoent_calculator
///
/// @Author junhua
/// @Date 2024/3/11
/// xy轴计算类
class XYComponentCalculator<T extends Entry<double, double>> extends BaseChartCalculator<T> {
  /// 获取轴线的上下文
  AxisContextCalculator axisContext;

  /// 获取轴线绘制的高度
  double get drawContentHeight => axisContext.drawContentHeight;

  /// 获取绘制内容的宽度
  double get drawContentWidth => axisContext.drawContentWidth;

  double get halfItemWidth => axisContext.itemWidth / 2;

  double get leftOffset => axisContext.axisLeftOffset;

  double get topOffset => axisContext.chartContentTopOffset;

  double get startIndex => axisContext.startIndex;

  double get displayCount => axisContext.displayCount;

  /// 绘制的起点
  int get begin => startIndex.toInt();

  /// 绘制的终点
  int get end => min((startIndex + displayCount).ceil(), entryList.length);

  /// 轴是否限制了超过范围
  bool get yAxisLabelCanExceedAxisLine => axisContext.yAxisLabelCanExceedAxisLine;

  /// 轴是否可以超过范围
  bool get xAxisLabelCanExceedAxisLine => axisContext.xAxisLabelCanExceedAxisLine;

  /// 竖直方向上的偏移量
  double get axisHeight => axisContext.drawContentHeight;

  /// 水平方向上的偏移量
  double get axisWidth => axisContext.drawChartWidth;

  double get xAxisLineWidth => axisContext.xAxisLineWidth;

  bool get showYLabelInner => axisContext.yAxisLabelInside;

  /// 数据源
  List<T> get entryList => dataSet.data;

  /// item的宽度
  double get itemWidth => axisContext.itemWidth;

  /// item的间距
  double get itemMargin => axisContext.itemMargin;

  XYComponentCalculator(super.dataSet, this.axisContext);

  /// 从startIndex处绘制
  double getXOffsetWithItem(int index) {
    // 这里参考牛牛 增加 一半的item宽度
    return axisContext.getXOffsetByDataIndex(index - startIndex) + halfItemWidth;
  }

  /// 从startIndex处绘制
  double getXOffset(int index) {
    // 这里参考牛牛 增加 一半的item宽度
    return axisContext.getXOffsetByDataIndex(index - startIndex);
  }

  double getYOffset(double entryValue) {
    return axisContext.getYOffsetByDataValue(entryValue);
  }

  /// 根据传入的x值，获取对应的index
  int getXAxisIndexByXValue(double xValue) {
    return axisContext.getXAxisIndexByValue(xValue);
  }

  /// 根据传入的数据，构建折线的路径
  void buildLinePath(
    Path curvePath,
    Path? shaderPath,
    final double startIndex,
    final double displayCount,
    List<T> entryList,
    ValueProvider<T> valueProvider, {
    int offsetIndex = 0,
  }) {
    if (entryList.isEmpty) {
      return;
    }

    curvePath.reset();
    if (null != shaderPath) {
      shaderPath.reset();
    }

    double startYValue = double.negativeInfinity;
    // 折线图由于要做成连贯的，因此起始坐标需要-1，结束坐标需要+1
    int realStartIndex = max((startIndex - 1).floor(), 0);
    int endIndex = min((startIndex + displayCount + 1).ceil(), entryList.length);

    //先找到第一个点。
    while ((startYValue == double.negativeInfinity || startYValue == double.maxFinite) &&
        realStartIndex < endIndex) {
      T startEntry = entryList[realStartIndex];
      startYValue = valueProvider.call(startEntry, realStartIndex);
      realStartIndex++;
    }

    if (startYValue == double.negativeInfinity || startYValue == double.maxFinite) {
      return;
    }

    final double halfItemWidth = itemWidth / 2;

    double xOffset =
        axisContext.getXOffsetByDataIndex(realStartIndex - startIndex - 1 + offsetIndex) +
            halfItemWidth;
    double yOffset = axisContext.getYOffsetByDataValue(startYValue);

    curvePath.moveTo(xOffset, yOffset);
    if (null != shaderPath) {
      shaderPath.moveTo(xOffset, yOffset);
    }

    final double startXOffset = xOffset;
    final double startYOffset = yOffset;

    double endXOffset = xOffset;

    for (int index = realStartIndex; index < endIndex; index++) {
      T entry = entryList[index];
      if (entry.isValid) {
        double yValue = valueProvider.call(entry, index);
        if (yValue == double.negativeInfinity || yValue == double.maxFinite) {
          continue;
        }

        xOffset =
            axisContext.getXOffsetByDataIndex(index - startIndex + offsetIndex) + halfItemWidth;
        yOffset = axisContext.getYOffsetByDataValue(yValue);

        curvePath.lineTo(xOffset, yOffset);
        if (null != shaderPath) {
          shaderPath.lineTo(xOffset, yOffset);
        }

        endXOffset = xOffset;
      }
    }

    // 阴影需要把四边给封闭起来
    if (null != shaderPath) {
      shaderPath.lineTo(endXOffset, height);
      shaderPath.lineTo(startXOffset, height);
      shaderPath.lineTo(startXOffset, startYOffset);
    }
  }
}
