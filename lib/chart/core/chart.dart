import 'package:flutter/animation.dart';
import 'package:flutter_chart/chart/behavior/on_long_press_listener.dart';
import 'package:flutter_chart/chart/behavior/on_move_listener.dart';
import 'package:flutter_chart/chart/behavior/on_scale_listener.dart';
import 'package:flutter_chart/chart/behavior/on_tap_listener.dart';

/// Chart接口类，提供通用能力
///
/// @Author junhualin
/// @Date 2024/2/6 15:25
abstract class IChart {
  /// 内部调用State的setState方法
  void update(VoidCallback fn);

  /// 全局位置和本地位置的转换
  Offset convertGlobalPosToLocal(Offset offset);

  /// 获取vsync用于动画
  TickerProvider get vsync;

  /// 获取chart交互能力接口
  IGestureManager get gestureManager;
}

/// chart交互能力接口
abstract class IGestureManager {
  void addOnMoveListener(OnMoveListener listener);

  /// 从移动列表中清除
  void removeOnMoveListener(OnMoveListener listener);

  /// 注册render到事件缩放处理列表中
  void addOnScaleListener(OnScaleListener listener);

  /// 从列表中清除
  void removeOnScaleListener(OnScaleListener listener);

  /// 注册render到事件长按处理列表中
  void addOnLongPressListener(OnLongPressListener listener);

  /// 从列表中清除
  void removeOnLongPressListener(OnLongPressListener listener);

  /// 注册render到事件点击处理列表中
  void addOnTapListener(OnTapListener listener);

  /// 从列表中清楚
  void removeOnTapListener(OnTapListener listener);
}
