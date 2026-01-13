import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_data_set.dart';
import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/axis/xaxis_calculator.dart';
import 'package:flutter_chart/chart/axis/yaxis_calculator.dart';
import 'package:flutter_chart/chart/core/base_chart_calculator.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/provider/axis_value_provider.dart';
import 'package:flutter_chart/chart/provider/item_margin_provider.dart';

/// @Description 包含x轴，y轴的相关信息，使用calculator进行计算，
///
/// @Author junhua
/// @Date 2023/8/2
class AxisContextCalculator extends BaseChartCalculator<Entry<double, double>>
    implements IAxisContext {
  /// 默认缩放最小比例
  static const double _defaultScaleMinFactor = 0.5;

  /// 默认缩放最小比例
  static const double _defaultScaleMaxFactor = 3;

  /// 缩放点所在点的index
  double _scaleFocusIndex = -1;

  /// 缩放点的比例
  double _scaleFocusRadio = 0.5;

  /// 缩放比例
  double _scaleFactor = 1.0;

  /// 上一次的缩放比例
  double _lastScaleFactor = 1.0;

  /// 缩放最小比例
  double _scaleMinFactor;

  /// 缩放最大比例
  double _scaleMaxFactor;

  /// x轴数据转换
  AxisIndexProvider<AxisDataSet>? xAxisIndexProvider;

  /// x轴数据转换
  AxisValueProvider<AxisDataSet>? xAxisValueProvider;

  /// y轴数据转换
  AxisIndexProvider<AxisDataSet>? yAxisIndexProvider;

  /// y轴数据转换
  AxisValueProvider<AxisDataSet>? yAxisValueProvider;

  /// x轴的计算器
  late XAxisCalculator xAxisCalculator;

  /// y轴的计算器
  late YAxisCalculator yAxisCalculator;

  /// 轴数据
  AxisDataSet axisDataSet;

  /// item之间的宽度
  @override
  double get itemWidth => (drawContentWidth - displayCount * itemMargin) / displayCount;

  /// 最小item宽度
  late double _minItemWidth;

  /// 最大item宽度
  late double _maxItemWidth;

  /// item之间的margin
  @override
  double get itemMargin => _itemMargin;

  late double _itemMargin;

  /// 最小item间隔，用于计算缩放比例
  late double _minItemMargin;

  /// 最大item间隔，用于计算缩放比例
  late double _maxItemMargin;

  /// 绘制轴线时的左偏移量
  double get axisLeftOffset => _getAxisLeftOffset();

  /// x轴上左偏移量
  double _leftOffset = 0;

  /// 绘制表格的内容的宽度
  double get drawChartWidth => _getChartWidth();

  /// 绘制的轴的宽
  double _drawChartWidth = 0;

  /// 获取绘制的轴的宽度
  double get drawContentWidth => drawChartWidth - axisLeftOffset;

  /// 绘制轴线时竖直方向的偏移量,[axisTopOffset] + [drawContentHeight]
  double get drawContentHeight => _getDrawContentHeight();

  /// 绘制的轴的高
  double _drawContentHeight = 0;

  /// 绘制的x轴的数组数据
  List<double> get xAxisEntries => xAxisCalculator.axisEntrySet;

  /// 绘制的x轴的index数组数据
  List<int> get xAxisIndexEntries => xAxisCalculator.axisIndexEntrySet;

  /// 绘制的x轴的数组数据
  List<double> get yAxisEntries => yAxisCalculator.axisEntrySet;

  /// 绘制的x轴的数组数据
  List<int> get yAxisIndexEntries => yAxisCalculator.axisIndexEntrySet;

  /// y轴轴线的宽度
  double get yAxisLineWidth => yAxisCalculator.axisLineWidth;

  /// x轴轴线的宽度
  double get xAxisLineWidth => xAxisCalculator.axisLineWidth;

  /// 显示y轴标签
  bool get showYAxisLabel => yAxisCalculator.showLabel;

  /// 显示x轴标签
  bool get showXAxisLabel => xAxisCalculator.showLabel;

  /// 是否label显示在轴线内部
  bool get yAxisLabelInside => yAxisCalculator.labelShowInner;

  /// 初始的index
  @override
  double get startIndex => _startIndex;

  /// 绘制时开始的index值
  late double _startIndex;

  /// 最后一个有效的index
  double _lastValidIndex = 0;

  /// 展示的item的数目
  @override
  double get displayCount => _originDisplayCount / _scaleFactor;

  /// 原始的展示数目
  late double _originDisplayCount;

  /// 所有item的数目
  int get totalCount => axisDataSet.data.length;

  /// 整体图表的上偏移量
  double get topOffset => yAxisCalculator.getTopOffset();

  /// 绘制x,y轴内容的高度偏移量，这里参考nn，偏移了x轴线的宽度，确保绘制内容最低点时和轴线相交
  double get chartContentTopOffset => xAxisLineWidth + topOffset;

  /// y轴右边距
  double get yAxisTextRightMargin => yAxisCalculator.axisTextRightMargin;

  /// x轴上边距
  double get xAxisTextTopMargin => xAxisCalculator.axisTextTopMargin;

  /// y轴是否超过了范围
  get yAxisLabelCanExceedAxisLine => yAxisCalculator.labelCanExceedAxisLine;

  /// x轴是否超过了范围
  get xAxisLabelCanExceedAxisLine => xAxisCalculator.labelCanExceedAxisLine;

  /// itemMargin的提供者
  final ItemMarginProvider? itemMarginProvider;

  /// 构造函数
  AxisContextCalculator(
    this.axisDataSet, {
    required AxisSpec xAxisSpec,
    required AxisSpec yAxisSpec,
    required this.xAxisIndexProvider,
    required this.xAxisValueProvider,
    required this.yAxisIndexProvider,
    required this.yAxisValueProvider,
    this.itemMarginProvider,
  })  : _scaleMinFactor = _defaultScaleMinFactor,
        _scaleMaxFactor = _defaultScaleMaxFactor,
        super(axisDataSet) {
    _startIndex = axisDataSet.startIndex ?? 0;
    _originDisplayCount = axisDataSet.displayCount ?? axisDataSet.data.length.toDouble();
    _lastScaleFactor = axisDataSet.lastScaleFactor;
    _scaleFactor = axisDataSet.scaleFactor;
    _scaleFocusIndex = axisDataSet.scaleFocusIndex;
    _scaleFocusRadio = axisDataSet.scaleFocusRadio;
    _itemMargin = xAxisSpec.itemMargin;
    _minItemWidth = xAxisSpec.minItemWidth;
    _maxItemWidth = xAxisSpec.maxItemWidth;
    _minItemMargin = xAxisSpec.minItemMargin;
    _maxItemMargin = xAxisSpec.maxItemMargin;

    xAxisCalculator = XAxisCalculator(
      axisDataSet,
      this,
      axisSpec: xAxisSpec,
      axisIndexProvider: xAxisIndexProvider,
      axisValueProvider: xAxisValueProvider,
    );
    yAxisCalculator = YAxisCalculator(
      axisDataSet,
      this,
      axisSpec: yAxisSpec,
      axisValueProvider: yAxisValueProvider,
      axisIndexProvider: yAxisIndexProvider,
    );

    /// 确认最后一个index值，可以显示一半的柱形
    _lastValidIndex = dataSet.data.lastIndexWhere(
          (data) => data.isValid,
        ) +
        0.5;
  }

  /// 获取绘制图表的宽度
  double _getChartWidth() {
    if (width <= 0) return 0;
    if (_drawChartWidth == 0) {
      // 目前chart中没有margin或者padding的情况，直接使用width
      _drawChartWidth = width;
    }
    return _drawChartWidth;
  }

  /// 获取绘制的轴的高度，[axisTopOffset] + 绘制的y轴线的长度
  /// bottom offset 包括文本高度 + 轴线宽度 + padding大小
  double _getDrawContentHeight() {
    if (height <= 0) return 0;
    if (_drawContentHeight == 0) {
      _drawContentHeight =
          height - xAxisCalculator.getBottomOffset() - yAxisCalculator.getTopOffset();
    }
    return _drawContentHeight;
  }

  /// 获取坐标轴左边的偏移量
  double _getAxisLeftOffset() {
    if (_leftOffset == 0) {
      _leftOffset = yAxisCalculator.getAxisLeftOffset();
    }
    return _leftOffset;
  }

  /// 获取x轴的文本
  /// [index] x轴的数据的索引
  String getXAxisTextByAxisEntryIndex(int index) {
    return xAxisCalculator.getTextByAxisEntryIndex(index);
  }

  /// 获取x轴的文本
  /// [index] 数据源的索引
  String getXAxisTextByDataIndex(int index) {
    return xAxisCalculator.getTextByDataIndex(index);
  }

  /// 获取x方向上的偏移
  double getXOffsetByDataIndex(double index) {
    return xAxisCalculator.calAxisOffset(index, 0);
  }

  /// 获取x方向上的偏移
  double getXOffsetByDataIndexWithStartIndex(int index) {
    return xAxisCalculator.calAxisOffset(index - startIndex, 0);
  }

  /// 获取y方向上的偏移
  double getYOffsetByDataValue(num value) {
    return yAxisCalculator.calAxisOffset(0, value);
  }

  /// 获取y方向上的偏移
  double getYOffsetByDataIndex(int dataIndex) {
    return yAxisCalculator.calAxisOffset(0, dataSet.data[dataIndex].y);
  }

  /// 获取网格对应的y轴的文本
  /// [entryIndex] y轴的数据的索引
  String getYAxisLabelTextByAxisEntryIndex(int entryIndex) {
    return yAxisCalculator.getTextByAxisEntryIndex(entryIndex);
  }

  /// 获取网格对应的y轴的文本
  /// [entryValue] y轴上的坐标值
  String getYAxisLabelTextByDataValue(double entryValue) {
    return yAxisCalculator.getTextByDataValue(entryValue);
  }

  /// 计算x轴文本偏移量
  Offset getXAxisTextOffset(
    String text,
    TextStyle style,
    double xOffset,
    double yOffset,
    EdgeInsets margin,
  ) {
    return xAxisCalculator.getTextOffset(
      text,
      style,
      drawChartWidth,
      drawContentHeight,
      axisLeftOffset,
      xOffset,
      yOffset,
      margin,
    );
  }

  /// 计算y轴文本偏移量
  Offset getYAxisTextOffset(
    String text,
    TextStyle style,
    double xOffset,
    double yOffset,
    EdgeInsets margin,
  ) {
    return yAxisCalculator.getTextOffset(
      text,
      style,
      drawChartWidth,
      drawContentHeight,
      axisLeftOffset,
      xOffset,
      yOffset,
      margin,
    );
  }

  /// 根据手指的触摸坐标，获取在坐标轴系上的位置
  /// [x] 手指触摸坐标，需要和数据进行匹配，确认最近的x坐标
  /// [y] 手指触摸坐标，需要进行范围限制，在坐标轴内显示
  Offset getAxisOffsetOfHoldPos(double x, double y) {
    int index = getXAxisIndexOfHold(x);

    double offsetX = getXOffsetByDataIndex(index.toDouble()) + axisLeftOffset;
    double offSetY = y;
    if (y < 0) {
      offSetY = 0;
    } else if (y > drawContentHeight) {
      offSetY = drawContentHeight;
    }
    return Offset(offsetX, offSetY);
  }

  /// 根据当前手指所在x坐标，获取当前长按的索引
  /// [x] x坐标和最近的数据源进行匹配
  int getXAxisIndexOfHold(double x) {
    double contentDis = x - axisLeftOffset;
    return xAxisCalculator.getIndexOfOnHold(contentDis, startIndex);
  }

  /// 根据entry的值,获取在x轴上的索引
  int getXAxisIndexByValue(double xValue) {
    return xAxisCalculator.indexOfDataValue(xValue);
  }

  /// 根据位置，获取在数据中的值
  double getYAxisDataValueByPos(double pos) {
    return yAxisCalculator.getDataValueByPos(pos);
  }

  @override
  void setChartSize(Size size) {
    super.setChartSize(size);
    _notifyDataSetChange();
    _calculateMinAndMaxScale();
    xAxisCalculator.updateAxisLength(drawContentWidth);
    yAxisCalculator.updateAxisLength(drawContentHeight);
  }

  /// 计算缩放比例
  void _calculateMinAndMaxScale() {
    if (drawContentWidth <= 0) return;

    final maxScale = _calScale(_maxItemWidth, _maxItemMargin == 0 ? _itemMargin : _maxItemMargin);
    if (maxScale > _defaultScaleMinFactor) {
      _scaleMaxFactor = maxScale;
    }

    final minScale = _calScale(_minItemWidth, _minItemMargin == 0 ? _itemMargin : _minItemMargin);
    if (minScale < _defaultScaleMaxFactor && minScale > 0) {
      _scaleMinFactor = minScale;
    }
  }

  double _calScale(double itemWidth, double itemMargin) {
    final displayCount = (drawContentWidth - itemMargin) / (itemWidth + itemMargin);
    return _originDisplayCount / displayCount;
  }

  /// 计算文本宽度
  double calculateTextWidth(String text, TextStyle style) {
    return xAxisCalculator.getTextWidth(text, style);
  }

  /// 计算文本宽度
  double calculateTextHeight(String text, TextStyle style) {
    return xAxisCalculator.getTextHeight(text, style);
  }

  /// 水平移动
  /// @return 是否需要更新chart
  bool move(double xOffset, double yOffset) {
    // 移动的距离和坐标轴显示的位置相反，这里[xOffset]取反
    final indexOffset = -xOffset / (itemWidth + itemMargin);
    double newStartIndex = _startIndex + indexOffset;
    var totalCount = dataSet.data.length;
    if (newStartIndex + displayCount > totalCount) {
      // 限制向右移动
      newStartIndex = totalCount - displayCount;
    }
    newStartIndex = max(0, newStartIndex);

    // 如果此时移动大于最后一个有效的index值，则移动到最后一个有效值
    if (newStartIndex > _lastValidIndex) {
      newStartIndex = _lastValidIndex;
    }

    if (newStartIndex != _startIndex && newStartIndex <= _lastValidIndex) {
      var entry = dataSet.data[newStartIndex.floor()];

      // 不能将图表移动到非有效点的坐标上
      if (entry.isValid) {
        _startIndex = newStartIndex;
        _notifyDataSetChange();
        return true;
      }
    }
    return false;
  }

  /// 缩放开始，先确定缩放点和缩放比例
  onScaleBegin(double centerX, double centerY) {
    if (centerX > 0) {
      final focusX = centerX - axisLeftOffset;
      _scaleFocusRadio = focusX / drawContentWidth;
    }

    _scaleFocusIndex = displayCount * _scaleFocusRadio + startIndex - 1;
    _setFocusIndexAndRadio();
  }

  /// 缩放变化
  /// @return 是否需要更新chart
  bool onScaleChange(double originCurrentScale) {
    final currentScale =
        max(_scaleMinFactor, min(originCurrentScale * _lastScaleFactor, _scaleMaxFactor));

    final nowDisplayCount = _originDisplayCount / currentScale;
    // 缩放比例太小，不足以改变，暂不处理
    if (displayCount == nowDisplayCount) return false;
    _scaleFactor = currentScale;
    if (_scaleFocusIndex == -1) {
      _scaleFocusRadio = 0.5;
      _scaleFocusIndex = (displayCount * _scaleFocusRadio) + startIndex;
      _setFocusIndexAndRadio();
    }

    double newStartIndex = _scaleFocusIndex + 1 - nowDisplayCount * _scaleFocusRadio;
    final totalCount = dataSet.data.length;
    if (newStartIndex + nowDisplayCount > totalCount) {
      newStartIndex = totalCount - nowDisplayCount;
    }
    newStartIndex = max(0, newStartIndex);

    // 有效数据才缩放
    Entry entry = dataSet.data[newStartIndex.round()];
    if (entry.isValid) {
      _startIndex = newStartIndex;
      if (itemMarginProvider != null) {
        _itemMargin = itemMarginProvider!.setItemMargin(nowDisplayCount, drawContentWidth);
      }
      _notifyDataSetChange();
    }

    return true;
  }

  /// 缩放结束，缩放中心点默认为0.5处，为后续点击放大图标
  onScaleEnd() {
    _lastScaleFactor = _scaleFactor;
    axisDataSet.lastScaleFactor = _lastScaleFactor;
    _scaleFocusRadio = 0.5;
    _scaleFocusIndex = (displayCount / 2) + startIndex - 1;
    _setFocusIndexAndRadio();
  }

  /// 将缩放点和缩放比例设置到数据源中
  _setFocusIndexAndRadio() {
    axisDataSet.scaleFocusIndex = _scaleFocusIndex;
    axisDataSet.scaleFocusRadio = _scaleFocusRadio;
  }

  /// 数据发生变化后，重新构建
  void _notifyDataSetChange() {
    axisDataSet.startIndex = startIndex;
    axisDataSet.displayCount = _originDisplayCount;
    axisDataSet.scaleFactor = _scaleFactor;
    axisDataSet.calculateMinMaxAxisValues();
    xAxisCalculator.notifyDataSetChange();
    yAxisCalculator.notifyDataSetChange();
  }
}

abstract class IAxisContext {
  double get itemWidth;

  double get itemMargin;

  double get startIndex;

  double get displayCount;
}
