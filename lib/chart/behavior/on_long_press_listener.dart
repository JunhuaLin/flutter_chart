import 'package:flutter/gestures.dart';

/// @Description 长按时的监听回调
///
/// @Author junhua
/// @Date 2023/8/15
abstract class OnLongPressListener {
  /// 长按时的回调
  void onLongPress(Offset touchOffset);

  /// 长按时松开的回调
  void onLongPressUp();

  /// 长按时的点击
  void onLongPressDown();
}
