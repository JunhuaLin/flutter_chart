import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/axis_context_calculator.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/candle/candle_entry.dart';
import 'package:flutter_chart/chart/candle/candle_stick_chart_data.dart';

/// FileName candle_stick_calculator
///
/// @Author junhua
/// @Date 2024/3/11
/// 蜡烛图图表计算器
class CandleStickCalculator extends XYComponentCalculator<CandleEntry> {
  CandleStickChartData candleDataSet;

  CandleStickCalculator(this.candleDataSet, AxisContextCalculator axisContext)
      : super(candleDataSet, axisContext);

  /// 获取蜡烛图的绘制矩形的坐标
  Rect getDrawCandleRect(double index, CandleEntry entry, bool needCutBorder, double borderWidth) {
    double leftPos = axisContext.getXOffsetByDataIndex(index);
    double rightPos = leftPos + itemWidth;

    var candleValueProvider = candleDataSet.candleValueProvider!;
    double topPos = axisContext.getYOffsetByDataValue(candleValueProvider.getTopValue(entry));
    double bottomPos = axisContext.getYOffsetByDataValue(candleValueProvider.getBottomValue(entry));

    // 如果矩形的top和bottom的差值小于等于3个像素
    // 就把top和bottom设置成一样的值(top和bottom的中间值)
    // 不然绘制出来的矩形非常细很难看清
    final diff = (bottomPos - topPos).abs();
    if (diff <= 3) {
      topPos = (bottomPos + topPos) / 2;
      bottomPos = topPos;
    }

    // 空心蜡烛图由于边框会占据一部分空间
    // 为了保证蜡烛图的精确，矩形的四个边需要删掉半个边框的宽度
    if (needCutBorder) {
      final halfBorder = borderWidth * 0.5;
      leftPos += halfBorder;
      topPos += halfBorder;
      rightPos -= halfBorder;
      bottomPos -= halfBorder;
    }

    return Rect.fromLTRB(leftPos, min(topPos, bottomPos), rightPos, max(topPos, bottomPos));
  }

  /// 获取蜡烛图的最大和最小的Y轴偏移量
  ({double maxOffset, double minOffset}) getMinMaxYOffset(CandleEntry entry) {
    var candleValueProvider = candleDataSet.candleValueProvider!;
    var maxYOffset = axisContext.getYOffsetByDataValue(candleValueProvider.getHighValue(entry));
    var minYOffset = axisContext.getYOffsetByDataValue(candleValueProvider.getLowValue(entry));
    return (maxOffset: maxYOffset, minOffset: minYOffset);
  }

  /// 获取蜡烛图的最大和最小的Y轴偏移量
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
      yOffset = y - textHeight;
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
}
