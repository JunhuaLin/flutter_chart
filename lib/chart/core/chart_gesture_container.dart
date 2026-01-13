import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/behavior/chart_gesture_detector.dart';
import 'package:flutter_chart/chart/core/chart_gesture_manager.dart';

/// FileName chart_interaction_container
///

/// @Date 2024/3/4
/// @Description 默认的手势管理的容器, 增加DefaultInteractionChartContainer的类的原因在于使用State保存[ChartGestureManager]
/// 避免多次重建, 参考[DefaultTabController]的实现
class DefaultChartGestureContainer extends StatefulWidget {
  final Widget child;

  final ChartGestureManager? gestureManager;

  const DefaultChartGestureContainer({
    super.key,
    required this.child,
    this.gestureManager,
  });

  // 获取gestureManager
  static ChartGestureManager? of(BuildContext context, [bool dependent = false]) {
    return dependent
        ? context.dependOnInheritedWidgetOfExactType<_ChartGestureContainer>()?.gestureManager
        : context.getInheritedWidgetOfExactType<_ChartGestureContainer>()?.gestureManager;
  }

  @override
  State<DefaultChartGestureContainer> createState() => _DefaultChartGestureContainerState();
}

class _DefaultChartGestureContainerState extends State<DefaultChartGestureContainer>
    with SingleTickerProviderStateMixin {
  late final ChartGestureManager gestureManager = widget.gestureManager ?? ChartGestureManager();

  final tag = "DefaultInteractionChartContainer";

  /// 移动时动画控制器
  late AnimationController _animationController;

  /// 距离限制
  /// 参考[ScrollPhysics]中的[toleranceFor]
  late Tolerance tolerance;

  /// 滑动的pixel
  double _pixel = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tolerance = Tolerance(
        velocity: 1.0 / (0.050 * View.of(context).devicePixelRatio), // logical pixels per second
        distance: 1.0 / View.of(context).devicePixelRatio, // logical pixels
      );
    });

    _animationController = AnimationController.unbounded(
      vsync: this,
    )..addListener(() {
        final distance = _animationController.value - _pixel;
        _pixel = _animationController.value;
        if (distance != 0) {
          gestureManager.dispatchHorizontalDragUpdateEvent(Offset(distance, 0));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return _ChartGestureContainer(
      gestureManager: gestureManager,
      child: Builder(builder: (context) {
        final gestureManager = DefaultChartGestureContainer.of(context, true);

        /// 1. 在ChartGestureDetector中由于手势会存在冲突处理，比如在移动过程中[onLongPressMoveUpdate]和[onHorizontalDragUpdate]
        /// 会存在冲突，所以需要根据组件的特性，进行设置，设置为null时不会处理该事件
        /// 2. 由于[DefaultChartGestureContainer]可由外部设置，此时 gestureManager还没注册完成（chart还没调用addXXListener方法）
        /// ，所以需要在[gestureManager]的手势能力发生变化时进行重建，
        /// 此处利用了[InheritedNotifier]的能力，在手势能力发生变化时，触发重建
        return ChartGestureDetector(
          onTapDown: gestureManager?.hasTapListener ?? false
              ? (detail) {
                  gestureManager?.dispatchTapDownEvent(detail.localPosition);
                }
              : null,
          onLongPressDown: gestureManager?.hasLongPressListener ?? false
              ? (_) {
                  gestureManager?.dispatchLongPressDownEvent();
                }
              : null,
          onLongPressUp: gestureManager?.hasLongPressListener ?? false
              ? () {
                  gestureManager?.dispatchLongPressUpEvent();
                }
              : null,
          onLongPressStart: gestureManager?.hasLongPressListener ?? false
              ? (detail) {
                  gestureManager?.dispatchLongPressTouchEvent(detail.globalPosition);
                }
              : null,
          onLongPressMoveUpdate: gestureManager?.hasLongPressListener ?? false
              ? (detail) {
                  gestureManager?.dispatchLongPressTouchEvent(detail.globalPosition);
                }
              : null,
          onHorizontalDragDown: gestureManager?.hasMoveListener ?? false
              ? (detail) {
                  _animationController.stop();
                }
              : null,
          onHorizontalDragUpdate: gestureManager?.hasMoveListener ?? false
              ? (detail) {
                  gestureManager?.dispatchHorizontalDragUpdateEvent(detail.delta);
                }
              : null,
          onHorizontalDragEnd: gestureManager?.hasMoveListener ?? false
              ? (details) {
                  // 开启动画，模拟滑动效果
                  _startAnimation(details.primaryVelocity ?? 0);
                }
              : null,
          onScaleStart: gestureManager?.hasScaleListener ?? false
              ? (detail) {
                  // https://github.com/flutter/flutter/issues/13102, 单指也会触发onScaleUpdate，增加手指数目的判断
                  if (detail.pointerCount >= 2) {
                    gestureManager?.dispatchScaleStartEvent(detail.focalPoint);
                  }
                }
              : null,
          onScaleUpdate: gestureManager?.hasScaleListener ?? false
              ? (detail) {
                  if (detail.pointerCount >= 2) {
                    gestureManager?.dispatchScaleUpdateEvent(detail.scale);
                  }
                }
              : null,
          onScaleEnd: gestureManager?.hasScaleListener ?? false
              ? (detail) {
                  // 缩放结束时，不需要判断手指数目
                  gestureManager?.dispatchScaleEndEvent();
                }
              : null,
          child: widget.child,
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  /// 启动动画，参考[BallisticScrollActivity]
  void _startAnimation(double velocity) {
    /// 每次启动时，重新设置[_pixel]
    _pixel = 0;

    /// 修改摩擦系数为0.03
    ClampingScrollSimulation clampingScrollSimulation = ClampingScrollSimulation(
        position: 0, velocity: velocity, tolerance: tolerance, friction: 0.03);
    _animationController.animateWith(clampingScrollSimulation);
  }
}

class _ChartGestureContainer extends InheritedNotifier<ChartGestureManager> {
  final ChartGestureManager gestureManager;

  const _ChartGestureContainer({
    Key? key,
    required Widget child,
    required this.gestureManager,
  }) : super(key: key, child: child, notifier: gestureManager);
}
