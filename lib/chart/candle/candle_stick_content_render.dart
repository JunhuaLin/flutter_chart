import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/candle/candle_entry.dart';
import 'package:flutter_chart/chart/candle/candle_stick_calculator.dart';
import 'package:flutter_chart/chart/candle/candle_stick_chart.dart';
import 'package:flutter_chart/chart/candle/candle_stick_spec.dart';

/// FileName CandleStickRender
///
/// @Author junhua
/// @Date 2024/3/11
class CandleStickContentRender extends XYChartContentRender<CandleStickCalculator> {
  /// 蜡烛图特性设置
  CandleStickSpec spec;

  /// 提供蜡烛图的最高最低文本展示转换
  ValueFormatter candleValueProvider;

  /// 绘制蜡烛图
  final Paint _candlePaint;

  /// 绘制label轴线
  final Paint _labelLinePaint;

  /// 绘制轴线画笔
  final TextPainter _textPainter;

  /// 绘制轴线的文字样式
  final TextStyle _textStyle;

  /// 绿色矩形
  final Path _greenCandlePath = Path();

  /// 绿色影线
  final Path _greenShadowPath = Path();

  /// 标志是否绘制path
  bool _isDrawGreenPath = false;

  /// 红色矩形
  final Path _redCandlePath = Path();

  /// 红色影线
  final Path _redShadowPath = Path();

  /// 标志是否绘制path
  bool _isDrawRedPath = false;

  /// 最高价格
  double _maxPrice = double.negativeInfinity;

  /// 最高价格所在x轴坐标
  double _maxPriceX = 0;

  /// 最低价格所在y轴坐标
  double _maxPriceY = 0;

  /// 最低价格
  double _minPrice = double.maxFinite;

  /// 最低价格所在x轴坐标
  double _minPriceX = 0;

  /// 最低价格所在y轴坐标
  double _minPriceY = 0;

  /// 构造函数
  CandleStickContentRender(super.calculator, this.spec, this.candleValueProvider, {super.level})
      : _candlePaint = Paint()..style = PaintingStyle.stroke,
        _textPainter = TextPainter(
          textDirection: TextDirection.ltr,
        ),
        _labelLinePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = spec.labelLineColor
          ..strokeWidth = spec.labelLineWidth,
        _textStyle = spec.labelTextStyle;

  @override
  void drawContent(
    Canvas canvas,
    CandleStickCalculator calculator,
    double contentWidth,
    double contentHeight,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    var itemWidth = calculator.itemWidth;
    // itemWidth宽度小于边框宽度的2倍时，边框宽度设置为itemWidth的一半
    // 避免宽度过小而边框过宽导致绘制出现挤压
    double borderWidth =
        (itemWidth < spec.barStrokeWidth) ? max(itemWidth / 2, 1) : spec.barStrokeWidth;
    _drawCandle(
      calculator,
      canvas,
      calculator.startIndex,
      calculator.displayCount,
      borderWidth,
      calculator.begin,
      calculator.end,
      calculator.entryList,
    );
  }

  /// 绘制蜡烛图路径，所有path计算完成后，统一绘制，避免多次绘制耗时
  void _drawCandle(
    CandleStickCalculator calculator,
    Canvas canvas,
    double startIndex,
    double displayCount,
    double borderWidth,
    int begin,
    int end,
    List<CandleEntry> values,
  ) {
    // 设置蜡烛图画笔边框宽度
    _redCandlePath.reset();
    _redShadowPath.reset();
    _greenCandlePath.reset();
    _greenShadowPath.reset();
    _maxPrice = double.negativeInfinity;
    _minPrice = double.maxFinite;

    for (int index = begin; index < end; index++) {
      CandleEntry entry = values[index];
      if (entry.isValid) {
        var candleColor = spec.candleColorProvider.call(index);
        switch (candleColor) {
          case CandleColor.red:
            _isDrawRedPath = true;
            _buildCandlePath(
              calculator,
              _redCandlePath,
              _redShadowPath,
              index - startIndex,
              borderWidth,
              entry,
              spec.hollowColor == CandleColor.red,
            );
            break;

          case CandleColor.green:
            _isDrawGreenPath = true;
            _buildCandlePath(
              calculator,
              _greenCandlePath,
              _greenShadowPath,
              index - startIndex,
              borderWidth,
              entry,
              spec.hollowColor == CandleColor.green,
            );
            break;
        }
      }
    }

    _candlePaint.strokeWidth = borderWidth;
    if (_isDrawRedPath) {
      _candlePaint.color = CandleColor.red.color;
      _candlePaint.style = spec.redCandleHollow ? PaintingStyle.stroke : PaintingStyle.fill;
      canvas.drawPath(_redCandlePath, _candlePaint);

      _candlePaint.style = PaintingStyle.stroke;
      canvas.drawPath(_redShadowPath, _candlePaint);
    }

    if (_isDrawGreenPath) {
      _candlePaint.color = CandleColor.green.color;
      _candlePaint.style = spec.greenCandleHollow ? PaintingStyle.stroke : PaintingStyle.fill;
      canvas.drawPath(_greenCandlePath, _candlePaint);

      _candlePaint.style = PaintingStyle.stroke;
      canvas.drawPath(_greenShadowPath, _candlePaint);
    }

    if (spec.showHighLowPriceLabel) {
      _drawLabel(
        calculator,
        canvas,
        _maxPriceX,
        _maxPriceY,
        candleValueProvider.call(_maxPrice),
        true,
      );
      _drawLabel(
        calculator,
        canvas,
        _minPriceX,
        _minPriceY,
        candleValueProvider.call(_minPrice),
        false,
      );
    }
  }

  /// 绘制蜡烛图路径
  void _buildCandlePath(CandleStickCalculator calculator, Path candlePath, Path shadowPath,
      double index, double borderWidth, CandleEntry candleEntry, bool needCutBorder) {
    Rect rect = calculator.getDrawCandleRect(index, candleEntry, needCutBorder, borderWidth);
    final candleBottom = rect.bottom;
    final candleLeft = rect.left;
    final candleRight = rect.right;
    final candleTop = rect.top;
    if (candleBottom == rect.top) {
      // 矩形的top和bottom一样时 用shadowPath直接画一条线
      // candlePath在实心蜡烛图时style设置的时fill，不好直接画出直线，这里直接用影线的path绘制
      shadowPath.moveTo(candleLeft, candleBottom);
      shadowPath.lineTo(rect.right, candleBottom);
    } else {
      // path构建一个矩形
      candlePath.addRect(Rect.fromLTRB(candleLeft, candleTop, candleRight, candleBottom));
    }

    final shadowOffsetX = (candleLeft + candleRight) / 2;
    var minMaxYOffset = calculator.getMinMaxYOffset(candleEntry);
    final maxYOffset = minMaxYOffset.maxOffset;
    final minYOffset = minMaxYOffset.minOffset;

    // 上影线
    if (maxYOffset < candleTop) {
      shadowPath.moveTo(shadowOffsetX, maxYOffset);
      shadowPath.lineTo(shadowOffsetX, candleTop);
    }

    // 下影线
    if (minYOffset > candleBottom) {
      shadowPath.moveTo(shadowOffsetX, candleBottom);
      shadowPath.lineTo(shadowOffsetX, minYOffset);
    }

    if (spec.showHighLowPriceLabel) {
      // 对比最高
      if (candleEntry.high >= _maxPrice) {
        _maxPrice = candleEntry.high;
        _maxPriceX = shadowOffsetX;
        _maxPriceY = min(maxYOffset, candleTop);
      }

      // 对比最低
      if (candleEntry.low <= _minPrice) {
        _minPrice = candleEntry.low;
        _minPriceX = shadowOffsetX;
        _minPriceY = max(minYOffset, candleBottom);
      }
    }
  }

  /// 绘制最低最高标签
  void _drawLabel(
    CandleStickCalculator calculator,
    Canvas canvas,
    double x,
    double y,
    String text,
    bool isMaxLabel,
  ) {
    if (text.isEmpty) return;

    // 画线
    var labelOffset = calculator.getLabelOffset(text, _textStyle, x, y, isMaxLabel);
    Offset labelLineOffset = labelOffset.item1;
    double textYOffset = labelOffset.item2;
    double textWidth = labelOffset.item3;
    canvas.drawLine(Offset(x, y), labelLineOffset, _labelLinePaint);

    // 绘制文本
    _textPainter
      ..textAlign = labelLineOffset.dx < x ? TextAlign.right : TextAlign.left
      ..text = TextSpan(text: text, style: _textStyle)
      ..layout();
    _textPainter.paint(
        canvas,
        Offset(labelLineOffset.dx > x ? labelLineOffset.dx : labelLineOffset.dx - textWidth,
            textYOffset));
  }
}
