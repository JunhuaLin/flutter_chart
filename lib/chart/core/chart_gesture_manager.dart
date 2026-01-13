import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/behavior/on_long_press_listener.dart';
import 'package:flutter_chart/chart/behavior/on_move_listener.dart';
import 'package:flutter_chart/chart/behavior/on_scale_listener.dart';
import 'package:flutter_chart/chart/behavior/on_tap_listener.dart';
import 'package:flutter_chart/chart/chart_const.dart';
import 'package:flutter_chart/chart/core/chart.dart';

/// @Description 负责事件管理类
///
/// @Author junhua
/// @Date 2023/8/22
class ChartGestureManager extends ChangeNotifier implements IGestureManager {
  /// 上次手势hold的位置，用于区分前后操作的位置是否发生了变化
  Offset _lastHoldPos = ChartConst.defaultTouchOffset;

  /// 是否处于缩放中
  bool _isScale = false;

  /// 是否处于长按中
  bool _isLongPress = false;

  /// 是否支持移动
  bool get hasMoveListener => _moveListenerList.isNotEmpty;

  /// 是否支持缩放
  bool get hasScaleListener => _scaleListenerList.isNotEmpty;

  /// 是否支持长按
  bool get hasLongPressListener => _longPressListenerList.isNotEmpty;

  /// 是否支持点击
  bool get hasTapListener => _tapListenerList.isNotEmpty;

  /// 是否支持交互
  bool get hasGestureListener =>
      hasMoveListener || hasScaleListener || hasLongPressListener || hasTapListener;

  /// render的事件列表
  final List<OnMoveListener> _moveListenerList = [];

  final List<OnScaleListener> _scaleListenerList = [];

  final List<OnLongPressListener> _longPressListenerList = [];

  final List<OnTapListener> _tapListenerList = [];

  /// 注册render到事件移动处理列表中
  @override
  void addOnMoveListener(OnMoveListener listener) {
    if (_moveListenerList.contains(listener)) return;

    /// 初次变化时，发出通知，
    if (!hasMoveListener) _notifyListeners();
    _moveListenerList.add(listener);
  }

  /// 从移动列表中清除
  @override
  void removeOnMoveListener(OnMoveListener listener) {
    _moveListenerList.remove(listener);
  }

  /// 注册render到事件缩放处理列表中
  @override
  void addOnScaleListener(OnScaleListener listener) {
    if (_scaleListenerList.contains(listener)) return;
    if (!hasScaleListener) _notifyListeners();
    _scaleListenerList.add(listener);
  }

  /// 从移动列表中清除
  @override
  void removeOnScaleListener(OnScaleListener listener) {
    _scaleListenerList.remove(listener);
  }

  /// 注册render到事件长按处理列表中
  @override
  void addOnLongPressListener(OnLongPressListener listener) {
    if (_longPressListenerList.contains(listener)) return;
    if (!hasLongPressListener) _notifyListeners();
    _longPressListenerList.add(listener);
  }

  /// 从移动列表中清除
  @override
  void removeOnLongPressListener(OnLongPressListener listener) {
    _longPressListenerList.remove(listener);
  }

  /// 注册render到事件移动处理列表中
  @override
  void addOnTapListener(OnTapListener listener) {
    if (_tapListenerList.contains(listener)) return;
    if (!hasTapListener) _notifyListeners();
    _tapListenerList.add(listener);
  }

  /// 当[ChartGestureManager]的[hasTapListener],[hasLongPressListener],[hasScaleListener],[hasMoveListener]
  /// 发生变化时，需要通知[ChartGestureDetector]组件重建
  @override
  void _notifyListeners() {
    /// 由于是在initState过程中调用，所以需要放在下一帧进行处理
    WidgetsBinding.instance.addPostFrameCallback((_) {
      super.notifyListeners();
    });
  }

  /// 从移动列表中清楚
  @override
  void removeOnTapListener(OnTapListener listener) {
    _tapListenerList.remove(listener);
  }

  /// 分发长按事件
  void dispatchLongPressTouchEvent(Offset position) {
    // 当初处于缩放过程，或者触摸位置没有发生变化，不处理长按事件
    final holdPos = Offset(position.dx, position.dy);
    if (_isScale || _lastHoldPos == holdPos) {
      return;
    }

    _isLongPress = true;
    _lastHoldPos = holdPos;
    _handleLongPressTouchEvent(holdPos);
  }

  /// 分发长按点击事件
  void dispatchLongPressDownEvent() {
    for (var listener in _longPressListenerList) {
      listener.onLongPressDown();
    }
  }

  /// 分发长按释放事件
  void dispatchLongPressUpEvent() {
    // 当前处于长按的过程中
    if (_isLongPress) {
      for (var listener in _longPressListenerList) {
        listener.onLongPressUp();
      }

      _isLongPress = false;
      _lastHoldPos = ChartConst.defaultTouchOffset;
    }
  }

  /// 分发单击事件
  void dispatchTapDownEvent(Offset position) {
    /// 分发单击事件
    for (var listener in _tapListenerList) {
      listener.onTapDown(position);
    }
  }

  void _handleLongPressTouchEvent(Offset position) {
    /// 分发长按事件
    for (var listener in _longPressListenerList) {
      listener.onLongPress(
        position == ChartConst.defaultTouchOffset ? ChartConst.defaultTouchOffset : position,
      );
    }
  }

  /// 分发滑动事件
  /// [delta] 滑动距离
  void dispatchHorizontalDragUpdateEvent(Offset delta) {
    // 当前处于缩放中，不处理滑动事件
    if (_isScale) return;
    for (var listener in _moveListenerList) {
      listener.onMove(delta.dx, delta.dy);
    }
  }

  /// 分发缩放事件开始
  void dispatchScaleStartEvent(Offset offset) {
    _dispatchScaleEvent((listener) {
      listener.onScaleStart(offset.dx, offset.dy);
    });
  }

  /// 分发缩放事件更新
  void dispatchScaleUpdateEvent(double scale) {
    _isScale = _dispatchScaleEvent((listener) => listener.onScaleUpdate(scale));
  }

  /// 分发缩放事件结束
  void dispatchScaleEndEvent() {
    _dispatchScaleEvent((listener) => listener.onScaleEnd());
    _isScale = false;
  }

  /// 分发缩放事件，并判断是否存在listener消费事件
  /// @return 是否存在处理缩放事件
  bool _dispatchScaleEvent(Function(OnScaleListener) scaleFunction) {
    bool hasScaleListener = false;

    // 处于长按过程中时，不处理缩放事件
    if (_isLongPress) return hasScaleListener;

    for (var listener in _scaleListenerList) {
      scaleFunction.call(listener);
      hasScaleListener = true;
    }
    return hasScaleListener;
  }
}
