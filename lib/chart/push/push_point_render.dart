import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/axis/xy_chart_content_render.dart';
import 'package:flutter_chart/chart/axis/xycompoent_calculator.dart';
import 'package:flutter_chart/chart/core/chart.dart';
import 'package:flutter_chart/chart/data/entry.dart';
import 'package:flutter_chart/chart/push/push_point_spec.dart';

/// FileName push_point_render
///
/// @Author junhua
/// @Date 2024/3/14
/// @Description 推送点动画显示
class PushPointRender<T extends Entry<double, double>>
    extends XYChartContentRender<XYComponentCalculator<T>> {
  /// 推送点特性
  PushPointSpec spec;

  /// 动画控制器
  late AnimationController _controller;

  /// 动画
  late Animation<double> _animation;

  /// 推送点动画绘制
  final Paint _pushPointPaint;

  /// 重新绘制
  bool _needPaint = false;

  /// 推送点
  final T? pushEntry;

  PushPointRender(
    super.calculator, {
    this.spec = const PushPointSpec(),
    this.pushEntry,
  }) : _pushPointPaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = spec.strokeWidth;

  @override
  void onInit(IChart chart) {
    super.onInit(chart);
    _controller = AnimationController(
      duration: spec.duration,
      vsync: chart.vsync,
    );
    _needPaint = false;
    _animation = PushTween(
      begin: 0.5,
      middle: 1,
      end: 0,
    ).animate(_controller)
      ..addListener(() {
        _needPaint = true;
        update();
      })
      ..addStatusListener((status) {
        // 动画结束，停止动画
        if (status == AnimationStatus.completed) {
          restAnimation();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 启动动画
  void startAnimation() {
    restAnimation();
    _controller.forward();
  }

  /// 结束动画
  void restAnimation() {
    _controller.reset();
    _needPaint = false;
  }

  @override
  void drawContent(
    Canvas canvas,
    XYComponentCalculator calculator,
    double contentWidth,
    double contentHeight,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
  ) {
    if (_needPaint) {
      drawPushPoint(
        canvas,
        calculator,
        calculator.drawContentWidth,
        calculator.drawContentHeight,
        calculator.startIndex.toDouble(),
        calculator.displayCount,
        calculator.itemWidth,
        calculator.itemMargin,
        calculator.begin,
        calculator.end,
        _animation.value,
      );
    }
  }

  /// 绘制推送点方法，子类可实现
  void drawPushPoint(
    Canvas canvas,
    XYComponentCalculator calculator,
    double width,
    double height,
    double startIndex,
    double displayCount,
    double itemWidth,
    double itemMargin,
    int begin,
    int end,
    double animationProgress,
  ) {
    final entryList = calculator.entryList;
    int? drawIndex;

    // 优先绘制推送点
    if (pushEntry != null) {
      int index = calculator.getXAxisIndexByXValue(pushEntry!.x);
      if (index >= begin && index < end) {
        drawIndex = index;
      }
    } else {
      // 默认推送点为最后一个有效点，可以根据实际业务情况进行处理
      for (int i = entryList.length - 1; i >= begin; i--) {
        if (entryList[i].isValid) {
          // 在绘制范围内
          if (i <= end) {
            drawIndex = i;
            break;
          } else {
            // 最后一个有效点不在绘制范围内，不绘制
            return;
          }
        }
      }
    }

    // 数据都无效，则不绘制
    if (drawIndex == null) return;

    double xOffset = calculator.getXOffsetWithItem(drawIndex);
    double yOffset = calculator.getYOffset(entryList[drawIndex].y);
    if (spec.radius > xOffset) {
      xOffset = spec.radius;
    }

    if (spec.radius > width - xOffset) {
      xOffset = width - spec.radius;
    }

    if (spec.radius > yOffset) {
      yOffset = spec.radius;
    }

    if (spec.radius > height - yOffset) {
      yOffset = height - spec.radius;
    }

    final alpha = 255 * animationProgress;
    final radius = spec.radius * animationProgress;
    final color = spec.colorProvider?.call(entryList[drawIndex].y, drawIndex) ?? spec.color;
    _pushPointPaint.color = color.withOpacity(alpha / 255);
    canvas.drawCircle(Offset(xOffset, yOffset), radius, _pushPointPaint);
  }

  /// 获取绘制的索引
  int? getDrawIndex(
    XYComponentCalculator<T> calculator,
    List<T> entryList,
    int begin,
    int end,
  ) {
    int? drawIndex;
    for (int i = entryList.length - 1; i >= begin; i--) {
      if (entryList[i].isValid) {
        // 在绘制范围内
        if (i <= end) {
          drawIndex = i;
          break;
        }
      }
    }

    return drawIndex;
  }
}

/// 动画增加三个片段，参考牛牛的实现
class PushTween extends Animatable<double> {
  /// 动画初始值
  final double begin;

  /// 动画中间值
  final double middle;

  /// 动画结束值
  final double end;

  PushTween({
    required this.begin,
    required this.end,
    required this.middle,
  });

  @override
  double transform(double t) {
    if (t == 0) {
      return begin;
    } else if (t == 1) {
      return end;
    } else if (t > 0.5) {
      return middle + (end - middle) * (t - 0.5) * 2;
    } else {
      return begin + (middle - begin) * t * 2;
    }
  }
}
