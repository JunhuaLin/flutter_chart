import 'package:flutter/cupertino.dart';
import 'package:flutter_chart/chart/axis/axis_render.dart';
import 'package:flutter_chart/chart/behavior/behavior_callback.dart';
import 'package:flutter_chart/chart/behavior/on_move_listener.dart';
import 'package:flutter_chart/chart/behavior/on_scale_listener.dart';
import 'package:flutter_chart/chart/core/chart.dart';

/// @Description x轴render
///
/// @Author junhua
/// @Date 2023/8/3
class XAxisRender extends AxisRender implements OnMoveListener, OnScaleListener {
  @override
  List<double> get axisValueEntries => calculator.xAxisEntries;

  @override
  List<int> get indexEntries => calculator.xAxisIndexEntries;

  /// 是否支持水平移动
  bool enableMove;

  /// 是否支持水平缩放
  bool enableScale;

  /// 移动的回调
  final OnTransformCallBack? onMoveCallback;

  /// 缩放的回调
  final OnTransformCallBack? onScaleCallback;

  XAxisRender(
    super.calculator, {
    super.level,
    required super.axisSpec,
    this.enableMove = false,
    this.enableScale = false,
    this.onMoveCallback,
    this.onScaleCallback,
  });

  @override
  void onInit(IChart chart) {
    super.onInit(chart);
    if (enableMove) {
      chart.gestureManager.addOnMoveListener(this);
    }

    if (enableScale) {
      chart.gestureManager.addOnScaleListener(this);
    }
  }

  @override
  void drawAxisLine(
    Canvas canvas,
    double width,
    double height,
    double leftOffset,
    double xLineWidth,
    double yLineWidth,
  ) {
    canvas.drawLine(
      Offset(
        leftOffset - yLineWidth,
        height + xLineWidth / 2,
      ),
      Offset(
        width,
        height + xLineWidth / 2,
      ),
      axisLinePaint,
    );
  }

  @override
  void drawGridAndAxisLabel(
    Canvas canvas,
    double width,
    double height,
    double leftOffset,
    double xLineWidth,
    double yLineWidth,
    List<double> axisValueEntries,
    List<int> indexEntries,
    EdgeInsets margin,
  ) {
    bool showGridLine = axisSpec.showGirdLine;
    bool showLabel = axisSpec.showLabel;
    double xOffset;

    /// axis的index的集合
    List<int> axisIndexEntrySet = indexEntries;

    if (axisIndexEntrySet.isEmpty) {
      axisIndexEntrySet =
          axisValueEntries.map((entry) => calculator.getXAxisIndexByValue(entry)).toList();
    }

    Path gridLinePath = Path();
    for (int index = 0; index < axisIndexEntrySet.length; index++) {
      var entryIndex = axisIndexEntrySet[index];
      double visibleIndex = entryIndex - calculator.startIndex;

      xOffset = calculator.getXOffsetByDataIndex(visibleIndex);

      // 显示在屏幕外的不绘制
      showGridLine &= visibleIndex < calculator.displayCount;

      // 绘制时，需要整体向右偏移offset和右偏移半个item的宽度
      xOffset += (leftOffset + calculator.itemWidth / 2);

      if (showGridLine) {
        gridLinePath.reset();
        gridLinePath.moveTo(xOffset, 0);
        gridLinePath.lineTo(xOffset, height);
        
        if (axisSpec.gridLineUseDash) {
          dashPainter.draw(canvas, gridLinePath, gridLinePaint);
        } else {
          canvas.drawPath(gridLinePath, gridLinePaint);
        }
      }

      if (showLabel) {
        String text = calculator.getXAxisTextByAxisEntryIndex(index);
        Offset textOffset = calculator.getXAxisTextOffset(
          text,
          textStyle,
          xOffset,
          height,
          margin,
        );
        textPainter
          ..text = TextSpan(text: text, style: textStyle)
          ..layout();
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  @override
  void onMove(double xOffset, double yOffset) {
    double oldStartIndex = calculator.startIndex;
    if (calculator.move(xOffset, yOffset)) {
      update(() => onMoveCallback?.call(
            oldStartIndex,
            calculator.startIndex,
            calculator.displayCount,
            calculator.totalCount,
          ));
    }
  }

  @override
  void onScaleStart(double centerX, double centerY) {
    calculator.onScaleBegin(centerX, centerY);
  }

  @override
  void onScaleUpdate(double currentScale) {
    double oldStartIndex = calculator.startIndex;
    if (calculator.onScaleChange(currentScale)) {
      update(() => onScaleCallback?.call(
            oldStartIndex,
            calculator.startIndex,
            calculator.displayCount,
            calculator.totalCount,
          ));
    }
  }

  @override
  void onScaleEnd() {
    calculator.onScaleEnd();
  }

  @override
  void dispose() {
    super.dispose();
    if (enableMove) {
      chart.gestureManager.removeOnMoveListener(this);
    }
    if (enableScale) {
      chart.gestureManager.removeOnScaleListener(this);
    }
  }
}
