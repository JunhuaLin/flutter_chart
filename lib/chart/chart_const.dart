import 'dart:ui';

/// @Description chart的常量类
///
/// @Author junhua
/// @Date 2023/8/3
class ChartConst {
  /// chart绘制的level
  static const axisLevel = 5;

  /// chart绘制内容的level
  static const axisContentLevel = 6;

  /// 折线绘制的层级
  static const lineLevel = 8;

  /// 柱状图绘制的层级
  static const barLevel = 9;

  /// 十字星绘制的层级
  static const crossStitchLevel = 15;

  /// 默认的绘制层级
  static const defaultDrawLevel = 10;

  /// 手指触摸的默认坐标，认为是释放了手指长按操作
  static const defaultTouchPos = double.minPositive;

  /// 手指触摸的偏移量
  static const defaultTouchOffset = Offset(defaultTouchPos, defaultTouchPos);
}
