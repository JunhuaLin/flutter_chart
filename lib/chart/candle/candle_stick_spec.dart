import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// FileName candle_stick_spec
///
/// @Author junhua
/// @Date 2024/3/11
class CandleStickSpec extends Equatable {
  /// 是否空心
  final bool isHollow;

  /// label的style
  final TextStyle labelTextStyle;

  /// 绘制标签线的宽度
  final double labelLineWidth;

  /// 绘制标签线的颜色
  final Color labelLineColor;

  /// 影线的宽度以及空心蜡烛图边框宽度
  final double barStrokeWidth;

  /// 蜡烛图颜色, 使用[CandleColor]中的颜色
  final CandleColorProvider candleColorProvider;

  /// 空心蜡烛图的颜色
  final CandleColor hollowColor;

  /// 红色蜡烛是否是空心
  final bool redCandleHollow;

  /// 绿色蜡烛是否是空心
  final bool greenCandleHollow;

  /// 显示最高最低价格
  final bool showHighLowPriceLabel;

  /// 构造函数
  ///
  /// [isHollow] 是否空心
  const CandleStickSpec({
    this.isHollow = false,
    this.labelTextStyle = const TextStyle(fontSize: 8, color: Colors.black38),
    this.labelLineWidth = 0.5,
    this.barStrokeWidth = 1,
    this.hollowColor = CandleColor.red,
    this.labelLineColor = Colors.grey,
    this.redCandleHollow = false,
    this.greenCandleHollow = false,
    this.showHighLowPriceLabel = true,
    required this.candleColorProvider,
  });

  @override
  List<Object?> get props => [
        isHollow,
        labelTextStyle,
        labelLineWidth,
        barStrokeWidth,
        hollowColor,
        redCandleHollow,
        greenCandleHollow,
        showHighLowPriceLabel,
        labelLineColor,
        // Function 不能进行比较，每次的结果都是不一致
        // candleColorProvider,
      ];
}

typedef CandleColorProvider = CandleColor Function(int index);

/// 蜡烛图的颜色
enum CandleColor {
  red(Colors.red),
  green(Colors.green);

  final Color color;

  const CandleColor(this.color);
}
