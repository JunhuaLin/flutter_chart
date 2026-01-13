import 'package:flutter/painting.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/content/high_low_label/high_and_low_label_spec.dart';
import 'package:flutter_chart/chart/data/entry.dart';

/// FileName high_and_low_calculator
///
/// @Author junhua
/// @Date 2024/4/7
class HighAndLowCalculator<T extends Entry<double, double>> extends XYComponentCalculator<T> {
  /// 构造函数
  HighAndLowLabelSpec spec;

  HighAndLowCalculator(
    super.dataSet,
    super.axisContext, {
    required this.spec,
  });

  /// 获取[begin，end]区间内，最大值和最小值的索引
  ({int item1, int item2}) getMinAndMaxIndex(int begin, int end) {
    int minIndex = begin;
    int maxIndex = begin;
    for (int i = begin + 1; i < end; i++) {
      if (entryList[i].y < entryList[minIndex].y) {
        minIndex = i;
      }
      if (entryList[i].y > entryList[maxIndex].y) {
        maxIndex = i;
      }
    }

    return (item1: minIndex, item2: maxIndex);
  }

  /// 获取标签文本所在位置
  ({Offset item1, double item2, double item3}) getLabelOffset(
      String text, TextStyle textStyle, double x, double y, bool isMaxLabel) {
    var textWidth = axisContext.calculateTextWidth(text, textStyle);
    var textHeight = axisContext.calculateTextHeight(text, textStyle);

    final halfTextWidth = textWidth / 2;
    var xOffset = x + halfTextWidth;
    if (xOffset + textWidth > drawContentWidth) {
      xOffset = x - halfTextWidth;
    }

    final halfTextHeight = textHeight / 2;
    double yOffset;
    if (y < drawContentHeight / 2 && isMaxLabel) {
      /// 在上半部
      yOffset = y - halfTextHeight;
      if (yOffset - halfTextHeight < 0) {
        yOffset = y + textHeight;
      }
    } else {
      yOffset = y + halfTextHeight;
      if (yOffset + halfTextHeight > drawContentHeight) {
        yOffset = y - textHeight;
      }
    }

    return (item1: Offset(xOffset, yOffset), item2: yOffset - halfTextHeight, item3: textWidth);
  }

  /// 获取y方向的偏移量
  double getYOffsetWithIndex(int entryIndex) {
    return axisContext.getYOffsetByDataValue(entryList[entryIndex].y);
  }

  /// 获取文本
  String getYTextWithIndex(int entryIndex) {
    return spec.labelFormatter?.call(
          entryList[entryIndex].y,
          axisContext.startIndex,
          axisContext.displayCount,
        ) ??
        entryList[entryIndex].y.toString();
  }
}
