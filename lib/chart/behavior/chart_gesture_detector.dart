import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

/// FileName custom_scale_gesture_detector
///
/// @Author junhua
/// @Date 2024/3/7
/// @Description 解决外部使用listview容器时，会拦截缩放事件，增加[ChartScaleGestureRecognizer]处理
class ChartGestureDetector extends StatelessWidget {
  /// 点击响应
  final GestureTapDownCallback? onTapDown;

  /// 长按抬起
  final GestureLongPressUpCallback? onLongPressUp;

  /// 长按点击
  final GestureLongPressDownCallback? onLongPressDown;

  /// 长按开始
  final GestureLongPressStartCallback? onLongPressStart;

  /// 长按移动
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// 横向移动
  final GestureDragDownCallback? onHorizontalDragDown;

  /// 横向移动更新
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  /// 横向移动结束
  final GestureDragEndCallback? onHorizontalDragEnd;

  /// 缩放开始
  final GestureScaleStartCallback? onScaleStart;

  /// 缩放更新
  final GestureScaleUpdateCallback? onScaleUpdate;

  /// 缩放结束
  final GestureScaleEndCallback? onScaleEnd;

  /// 子widget
  final Widget? child;

  const ChartGestureDetector({
    super.key,
    this.child,
    this.onTapDown,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressDown,
    this.onLongPressUp,
    this.onHorizontalDragDown,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  });

  @override
  Widget build(BuildContext context) {
    final Map<Type, GestureRecognizerFactory> gestures = <Type, GestureRecognizerFactory>{};

    if (onScaleStart != null || onScaleUpdate != null || onScaleEnd != null) {
      // chart替换此处的ScaleGestureRecognizer
      gestures[ChartScaleGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<ChartScaleGestureRecognizer>(
        () => ChartScaleGestureRecognizer(
          debugOwner: this,
        ),
        (ChartScaleGestureRecognizer instance) {
          instance
            ..onStart = onScaleStart
            ..onUpdate = onScaleUpdate
            ..onEnd = onScaleEnd;
        },
      );
    }

    return RawGestureDetector(
      gestures: gestures,
      child: GestureDetector(
        onTapDown: onTapDown,
        onLongPressStart: onLongPressStart,
        onLongPressDown: onLongPressDown,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressUp: onLongPressUp,
        onHorizontalDragDown: onHorizontalDragDown,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onHorizontalDragEnd: onHorizontalDragEnd,
        child: child,
      ),
    );
  }
}

/// @Description 用于拦截缩放的手势事件，
class ChartScaleGestureRecognizer extends ScaleGestureRecognizer {
  ChartScaleGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    super.dragStartBehavior = DragStartBehavior.down,
    super.trackpadScrollCausesScale = false,
    super.trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
  });

  @override
  void rejectGesture(int pointer) {
    // 解决listView 包裹gestureDetector时，手势冲突问题，在手势事件被其他widget拦截时，仍然可以接收手势事件
    super.acceptGesture(pointer);
  }

  @override
  void acceptGesture(int pointer) {
    super.acceptGesture(pointer);
  }
}
