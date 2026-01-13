import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/axis/axis_data_set.dart';
import 'package:flutter_chart/chart/axis/axis_spec.dart';
import 'package:flutter_chart/chart/core/base_chart_calculator.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/provider/axis_value_provider.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';

/// @Description 绘制的轴线的计算器的抽象类
/// 数据分为dataset, entry
/// [axisEntrySet] 用于显示坐标轴label的数据，如y轴数据可以dataset的数据更大一些，x轴的数据则必须是在dataSet中
/// [dataSet] 用于绘制的数据，如折线图的数据，柱状图的数据，这里的数据必须是有序的
///
/// @Author junhua
/// @Date 2023/8/2
abstract class AxisCalculator extends BaseChartCalculator<Entry<num, num>> {
  /// 轴线特性
  AxisSpec axisSpec;

  /// 轴的数据集合
  List<double> axisEntrySet = [];

  /// 轴的index的数据集合
  List<int> axisIndexEntrySet = [];

  /// label样式
  TextStyle labelTextStyle;

  /// 轴坐标数据提供,提供的是轴的值，如y轴的值,
  final ListProvider<AxisDataSet>? _valueProvider;

  /// 轴坐标数据提供,提供的是轴上的index，如x轴上需要显示第一个和最后一个的index
  final ListIndexProvider<AxisDataSet>? _indexProvider;

  /// 轴坐标数据显示
  final StringProvider? _valueFormatter;

  /// 轴的长度
  late double axisLength;

  /// 缓存文字的宽高，避免每次重复请求
  final _textWidthCacheMap = {};

  /// 缓存文字的宽高，避免每次重复请求
  final _textHeightCacheMap = {};

  /// 数据源
  final AxisDataSet axisDataSet;

  /// 用于获取图表在缩放，移动过程中的属性，如[startIndex]
  final IAxisContext axisContext;

  /// item的宽度
  double get itemWidth => axisContext.itemWidth;

  /// item的间隔
  double get itemMargin => axisContext.itemMargin;

  /// 展示的数目
  double get displayCount => axisContext.displayCount;

  /// 起始的index
  double get startIndex => axisContext.startIndex;

  /// 线的宽度
  double get axisLineWidth => axisSpec.showAxisLine ? axisSpec.axisLineWidth : 0;

  /// 是否可以超过轴线
  bool get labelCanExceedAxisLine => axisSpec.labelCanExceedAxisLine;

  /// 数据的最小值
  double get dataMin;

  /// 数据的最大值
  double get dataMax;

  /// 是否显示标签
  bool get showLabel => axisSpec.showLabel;

  /// 是否标签显示在轴内
  bool get labelShowInner => axisSpec.drawInner;

  /// 构造函数
  AxisCalculator(
    this.axisDataSet,
    this.axisContext, {
    required this.axisSpec,
    AxisValueProvider<AxisDataSet>? axisValueProvider,
    AxisIndexProvider<AxisDataSet>? axisIndexProvider,
  })  : labelTextStyle = axisSpec.labelTextStyle,
        _valueProvider = axisValueProvider?.axisValueProvider,
        _indexProvider = axisIndexProvider?.axisIndexProvider,
        _valueFormatter =
            axisValueProvider?.axisValueFormatter ?? axisIndexProvider?.axisValueFormatter,
        super(axisDataSet) {
    notifyDataSetChange();
  }

  /// 根据轴[axisEntrySet]的index显示文本
  String getTextByAxisEntryIndex(int entryIndex) {
    if (axisEntrySet.isEmpty) {
      return "";
    }

    if (entryIndex < 0 || entryIndex >= axisEntrySet.length) {
      return "";
    }

    return getTextByDataValue(axisEntrySet[entryIndex]);
  }

  /// 根据[axisDataSet]的index显示文本
  String getTextByDataIndex(int dataSetIndex) {
    if (axisDataSet.data.isEmpty) {
      return "";
    }

    if (dataSetIndex < 0 || dataSetIndex >= axisDataSet.data.length) {
      return "";
    }

    return getTextByDataValue(axisDataSet.data[dataSetIndex].x.toDouble());
  }

  /// 根据value的值显示文本
  String getTextByDataValue(double dataValue) {
    String labStr = "";
    if (_valueFormatter != null) {
      labStr = _valueFormatter!(dataValue, startIndex, displayCount);
    } else {
      // 默认显示两位小数
      labStr = dataValue.toStringAsFixed(2);
    }
    return labStr;
  }

  /// 数据发生变化，如缩放之后，数据源发生变化，则需要重新设置轴上绘制的数据
  void notifyDataSetChange() {
    if (dataSet.data.isEmpty) {
      return;
    }

    axisEntrySet = initAxisEntries();
  }

  /// 轴方向的label的数据集合
  List<double> initAxisEntries() {
    // 优先使用valueProvider
    if (_valueProvider != null) {
      return _valueProvider!(
        axisDataSet,
        displayCount,
        startIndex,
      );
    } else if (_indexProvider != null) {
      axisIndexEntrySet = _indexProvider!(
        axisDataSet,
        displayCount,
        startIndex,
      );
      return indexToValue(axisIndexEntrySet);
    } else {
      // 只用于测试，在实际业务中，必须设置valueProvider
      // 轴根据标签数目显示
      double offset = (dataMax - dataMin) / (2 - 1);
      List<double> entries = List.filled(2, 0);
      for (int index = 0; index < 2; index++) {
        entries[index] = dataMin + index * offset;
      }
      return entries;
    }
  }

  /// 设置当前轴的宽度
  void updateAxisLength(double length) {
    axisLength = length;
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

  /// 计算entry值在轴方向的偏移量
  double calAxisOffset(double index, double entryValue);

  /// 子类实现，用于初始化根据index的值获取轴的数据
  List<double> indexToValue(List<int> indexList);

  /// 计算文本偏移量
  Offset getTextOffset(
    String text,
    TextStyle style,
    double drawAxisWidth,
    double drawAxisHeight,
    double startX,
    double xOffset,
    double yOffset,
    EdgeInsets textMargin,
  );
}

/// 文本的规格，用于进行缓存判断
class TextSpec {
  String text;
  TextStyle style;

  TextSpec(this.text, this.style);

  @override
  bool operator ==(Object other) {
    if (other is TextSpec) {
      return text == other.text && style == other.style;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(text, style);
}
