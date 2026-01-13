import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_calculator.dart';
import 'package:flutter_chart/chart/core/base_chart_calculator.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/horizontal_bar/horizontal_bar_chart.dart';
import 'package:flutter_chart/chart/horizontal_bar/horizontal_bar_spec.dart' show HorizontalBarSpec;
import 'package:flutter_chart/chart/util/ui_utils.dart';

/// Description: 柱状图计算器
///
/// Author: jingweixie
/// Date: 2023-08-15 19:56:21
class HorizontalBarCalculator extends BaseChartCalculator<Entry<num, num>> {
  /// 柱状图特性
  final HorizontalBarSpec barSpec;

  /// x轴显示转换
  final AxisLabelProvider? xAxisLabelProvider;

  /// x轴副label显示转换
  final AxisLabelProvider? xSecondaryAxisLabelProvider;

  /// 柱状图(不包括上下轴和文本)的y方向的偏移量
  late final double _barBottomVerOffset =
      _barHeight + barSpec.barMarginTop + (barSpec.showGridLine ? barSpec.gridLineWidth : 0);

  /// 柱状图每个item的宽度
  late final double _itemWidth = barWidth / dataSet.data.length;

  /// 柱状图（不包括上下轴线和文本）高度
  late final double _barHeight = _getBarHeight();

  /// 最大的y值
  late final num _maxVerValue = _getMaxVerValue();

  /// axisLabel文字的高度
  late final double _axisLabelHeight =
      getTextHeight(getAxisLabelString(0), barSpec.xAxisLabelStyle);

  /// secondary axisLabel文字的高度
  late final double _secondaryAxisLabelHeight =
      getTextHeight(getSecondaryAxisLabelString(0), barSpec.xSecondaryAxisLabelStyle);

  /// axisLabel y轴方向的偏移量
  late final double _axisLabelVerOffset =
      _barBottomVerOffset + barSpec.axisLineWidth + barSpec.xAxisLabelMargin.top;

  /// secondary axisLabel y轴方向的偏移量
  late final double _secondaryAxisLabelOffset =
      _axisLabelVerOffset + _axisLabelHeight + barSpec.xSecondaryAxisLabelMargin.top;

  /// 整个柱状图距离左边缘宽度
  double get barLeftMargin => barSpec.marginStart;

  /// 整个柱状图的宽度
  double get barWidth => (width - barSpec.marginStart - barSpec.marginEnd);

  /// 获取柱状图数据
  List<Entry<num, num>> get barDataList => dataSet.data;

  /// 缓存文字的宽，避免每次重复请求
  final _textWidthCacheMap = {};

  /// 缓存文字的高，避免每次重复请求
  final _textHeightCacheMap = {};

  /// x轴需要显示的文本缓存
  final _axisTextCacheMap = {};

  /// x轴副轴需要显示显示文本缓存
  final _secondaryAxisTextCacheMap = {};

  HorizontalBarCalculator(
    super.dataSet, {
    required this.barSpec,
    this.xAxisLabelProvider,
    this.xSecondaryAxisLabelProvider,
  });

  /// 获取柱状图中轴线开始和结束的偏移量
  (Offset, Offset) getAxisLineStartOffset() {
    var axisLineOffset = barSpec.axisLineWidth / 2;
    return (
      Offset(0, _barBottomVerOffset + axisLineOffset),
      Offset(barWidth, _barBottomVerOffset + axisLineOffset),
    );
  }

  /// 获取柱状图中网格线开始的偏移量
  List<Offset> getGridLineStartOffset() {
    List<Offset> offset = [];
    var gridLineCount = barSpec.gridLineCount;
    double margin = (_barBottomVerOffset - barSpec.gridLineWidth * gridLineCount) / gridLineCount;
    for (int i = 0; i < gridLineCount; i++) {
      offset.add(Offset(0, (margin + barSpec.gridLineWidth / 2) * i));
    }
    return offset;
  }

  /// 获取柱状图绘制位置
  Rect getDrawBarRect(int index) {
    // 获取居中的位置
    double middle = (index + 0.5) * _itemWidth;
    var barDistance = barSpec.barWidth / 2;
    double leftPos = middle - barDistance;
    double rightPos = middle + barDistance;

    var itemBarHeight = _barHeight * dataSet.data[index].y / _maxVerValue;
    double topPos = _barBottomVerOffset - itemBarHeight;
    double bottomPos = _barBottomVerOffset;

    return Rect.fromLTRB(leftPos, topPos, rightPos, bottomPos);
  }

  /// 获取柱状图中轴线的偏移量
  Offset getAxisLabelOffset(int index) {
    double middle = (index + 0.5) * _itemWidth;
    double leftOffset =
        middle - getTextWidth(getAxisLabelString(index), barSpec.xAxisLabelStyle) / 2;
    leftOffset = leftOffset < 0 ? 0 : leftOffset;
    return Offset(
      leftOffset,
      _axisLabelVerOffset,
    );
  }

  /// 获取柱状图中显示的文字
  String getAxisLabelString(int index) {
    return _axisTextCacheMap.putIfAbsent(index, () {
      return xAxisLabelProvider?.call(dataSet.data[index].x, barDataList[index].y, index) ?? "";
    });
  }

  /// 获取柱状图中轴线的偏移量
  Offset getSecondaryAxisLabelOffset(int index) {
    double middle = (index + 0.5) * _itemWidth;
    double leftOffset = middle -
        getTextWidth(getSecondaryAxisLabelString(index), barSpec.xSecondaryAxisLabelStyle) / 2;
    leftOffset = leftOffset < 0 ? 0 : leftOffset;
    return Offset(
      leftOffset,
      _secondaryAxisLabelOffset,
    );
  }

  /// 获取柱状图中显示的文字
  String getSecondaryAxisLabelString(int index) {
    return _secondaryAxisTextCacheMap.putIfAbsent(index, () {
      return xSecondaryAxisLabelProvider?.call(barDataList[index].x, barDataList[index].y, index) ??
          "";
    });
  }

  /// 获取柱状图（不包括上下轴线和文本）高度
  double _getBarHeight() {
    double axisLabelHeight =
        barSpec.showXAxisLabel ? _axisLabelHeight + barSpec.xAxisLabelMargin.top : 0;
    double secondaryAxisLabelHeight = barSpec.showXSecondaryAxisLabel
        ? _secondaryAxisLabelHeight + barSpec.xSecondaryAxisLabelMargin.top
        : 0;
    double gridLineHeight = barSpec.showGridLine ? barSpec.gridLineWidth : 0;
    double axisLineHeight = barSpec.axisLineWidth;
    return height -
        axisLabelHeight -
        secondaryAxisLabelHeight -
        gridLineHeight -
        axisLineHeight -
        barSpec.barMarginTop;
  }

  /// 获取x轴文本的宽度
  double getTextWidth(String text, TextStyle style) {
    return _textWidthCacheMap.putIfAbsent(
      TextSpec(text, style),
      () {
        return UiUtils.calculateTextWidth(text, style);
      },
    );
  }

  /// 获取x轴文本的宽度
  double getTextHeight(String text, TextStyle style) {
    return _textHeightCacheMap.putIfAbsent(
      TextSpec(text, style),
      () {
        return UiUtils.calculateTextHeight(text, style);
      },
    );
  }

  /// 获取最大值，比例显示
  num _getMaxVerValue() {
    num max = dataSet.data[0].y;
    for (int i = 1; i < dataSet.data.length; i++) {
      if (dataSet.data[i].y > max) {
        max = dataSet.data[i].y;
      }
    }

    return max;
  }
}
