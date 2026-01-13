import 'package:flutter/gestures.dart';

/// 单击按压手势监听
///
/// @Author theonlin
/// @Date 2023-11-28
abstract class OnTapListener {
  /// 单击时回调
  void onTapDown(Offset localPosition);
}
