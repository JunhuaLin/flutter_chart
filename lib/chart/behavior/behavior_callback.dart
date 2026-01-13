import 'dart:ui';

/// @Description 手势操作回调
///
/// @Author junhua
/// @Date 2023/8/1

/// 单击时的回调
typedef OnTapDownCallback = Function(int index);

/// 长按的回调
class OnLongPressCallback<D> {
  /// 长按时的回调
  final void Function(D data, int index)? onLongPress;

  /// 长按收起的回调
  final VoidCallback? onLongPressUp;

  const OnLongPressCallback({
    this.onLongPress,
    this.onLongPressUp,
  });
}

/// 移动或者缩放过程中的回调
typedef OnTransformCallBack = void Function(
  double oldStartIndex,
  double newStartIndex,
  double displayCount,
  int totalCount,
);
