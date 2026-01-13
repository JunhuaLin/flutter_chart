import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_chart/chart/behavior/on_tap_listener.dart';
import 'package:flutter_chart/chart/common/line.dart';
import 'package:flutter_chart/chart/core/base_chart_render.dart';
import 'package:flutter_chart/chart/core/chart.dart';
import 'package:flutter_chart/chart/pie/pie_calculator.dart';
import 'package:flutter_chart/chart/pie/pie_section.dart';
import 'package:flutter_chart/chart/pie/pie_spec.dart';

typedef SectionSelectedCallBack = void Function(PieSection section, int selectedIndex);

/// 饼图 Render
///
/// @Author theonlin
/// @Date 2023-11-27
class PieRender extends BaseChartRender<PieCalculator> implements OnTapListener {
  PieRender(
    super.calculator, {
    required this.spec,
    required this.selectedIndex,
    required this.enableTap,
    this.sectionSelectedCallBack,
  });

  /// 扇形 paint
  final Paint _sectionPaint = Paint();

  /// 圆中心 paint
  final Paint _centerSpacePaint = Paint();

  /// 绘制折线的特性
  final PieSpec spec;

  /// 扇形选中回调
  final SectionSelectedCallBack? sectionSelectedCallBack;

  /// 选中扇形索引
  int selectedIndex;

  /// 支持点击
  bool enableTap;

  /// 选中扇形的动画Controller
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void onInit(IChart chart) {
    super.onInit(chart);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: chart.vsync,
    );
    _resetCalculatorAndAnimation();
    _updateUIWithAnimation();
    if (enableTap) {
      chart.gestureManager.addOnTapListener(this);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    if (enableTap) {
      chart.gestureManager.removeOnTapListener(this);
    }
  }

  @override
  void onDraw(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final innerRadius = spec.innerRadius;
    final innerColor = spec.innerColor;
    if (innerRadius > 0 && innerColor != null) {
      _drawCenterSpace(canvas, center, innerRadius, innerColor);
    }

    final data = calculator.dataSet.data;
    if (data.length == 1) {
      _drawCircleSection(canvas, center);
      return;
    }

    for (var i = 0; i < data.length; i++) {
      final path = _generateSectionPath(i, center);
      final color = spec.sectionColor(i);
      _drawSection(canvas, path, color);
    }
  }

  @override
  void onTapDown(Offset localPosition) {
    final data = calculator.dataSet.data;
    final sectionsAngle = calculator.sectionDegrees;

    // 触摸位置
    final center = Offset(calculator.width / 2, calculator.height / 2);
    final touchedPoint = localPosition - center;
    final touchX = touchedPoint.dx;
    final touchY = touchedPoint.dy;

    // 触摸半径及角度
    final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));
    var touchAngle = calculator.degrees(math.atan2(touchY, touchX));
    touchAngle = touchAngle < 0 ? (180 - touchAngle.abs()) + 180 : touchAngle;
    final relativeTouchAngle = (touchAngle - spec.startDegreeOffset + 90) % 360;

    /// 在触摸点上找到最近的部分
    var tempAngle = 0.0;
    for (var i = 0; i < data.length; i++) {
      var sectionAngle = sectionsAngle[i];

      tempAngle %= 360;
      sectionAngle = data.length == 1 ? 360 : sectionAngle % 360;

      // 角度判定
      final space = spec.sectionSpace / 2;
      final fromDegree = tempAngle + space;
      final toDegree = sectionAngle + tempAngle - space;
      final isInDegree = relativeTouchAngle >= fromDegree && relativeTouchAngle <= toDegree;

      // 半径判定
      final centerRadius = spec.innerRadius;
      final sectionRadius = spec.outerRadius;
      final isInRadius = touchR > centerRadius && touchR <= sectionRadius;

      // 均符合判定则认为触摸到了该部分
      if (isInDegree && isInRadius) {
        _updateSelectedSection(i, data);
        break;
      }

      tempAngle += sectionAngle;
    }
  }

  void _drawCenterSpace(Canvas canvas, Offset center, double centerRadius, Color centerColor) {
    _centerSpacePaint.color = centerColor;
    canvas.drawCircle(
      center,
      centerRadius,
      _centerSpacePaint,
    );
  }

  void _drawCircleSection(Canvas canvas, Offset center) {
    final strokeWidth = spec.outerExpandRadius - spec.innerRadius;
    _sectionPaint
      ..color = spec.sectionColors.first
      ..strokeWidth = spec.outerExpandRadius - spec.innerRadius
      ..style = PaintingStyle.stroke;

    /// 圆环
    canvas.save();
    canvas.drawCircle(
      center,
      spec.innerRadius + strokeWidth / 2,
      _sectionPaint,
    );
    canvas.restore();
  }

  void _drawSection(Canvas canvas, Path path, Color color) {
    _sectionPaint
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, _sectionPaint);
  }

  Path _generateSectionPath(int index, Offset center) {
    final isSelected = selectedIndex == index;
    final sectionRadius = isSelected ? calculator.currentExpandRadius : spec.outerRadius;
    // 最大可视圆半径
    final sectionRadiusRect = Rect.fromCircle(
      center: center,
      radius: sectionRadius,
    );
    // 空白空间半径
    final centerRadiusRect = Rect.fromCircle(
      center: center,
      radius: spec.innerRadius,
    );

    final startLine = _startLine(index, center, sectionRadius);
    final endLine = _endLine(index, center, sectionRadius);
    final startRadian = calculator.startRadian(index);
    final sweepRadian = calculator.sweepRadian(index);
    final endRadian = calculator.endRadian(index);
    var sectionPath = Path()
      // 内环点
      ..moveTo(startLine.from.dx, startLine.from.dy)
      // 外环点
      ..lineTo(startLine.to.dx, startLine.to.dy)
      // 外弧
      ..arcTo(sectionRadiusRect, startRadian, sweepRadian, false)
      // 内环点
      ..lineTo(endLine.from.dx, endLine.from.dy)
      // 内弧
      ..arcTo(centerRadiusRect, endRadian, -sweepRadian, false)
      // 内环点
      ..moveTo(startLine.from.dx, startLine.from.dy)
      ..close();

    // 从 sectionPath 中减去 section 间隙
    if (spec.sectionSpace != 0) {
      // 以起始 chart.line 为中线创建一个宽度为 sectionSpace 矩形
      final startLineSeparatorPath = startLine.createRectPathAroundLine(spec.sectionSpace);
      // 以结束 chart.line 为中线创建一个宽度为 sectionSpace 矩形
      final endLineSeparatorPath = endLine.createRectPathAroundLine(spec.sectionSpace);

      try {
        sectionPath = Path.combine(
          PathOperation.difference,
          sectionPath,
          startLineSeparatorPath,
        );
        sectionPath = Path.combine(
          PathOperation.difference,
          sectionPath,
          endLineSeparatorPath,
        );
      } catch (e) {
        // [Path.combine] 在 web-html 中存在异常，可先忽略。
        // link: https://github.com/flutter/flutter/issues/44572
      }
    }

    return sectionPath;
  }

  /// 线段，起点为内环点，终点为外环点
  Line _startLine(int index, Offset center, double sectionRadius) {
    final startRadian = calculator.startRadian(index);
    // 角度向量，当 startRadian: 0 时 startLineDirection: (1, 0)
    final startLineDirection = Offset(math.cos(startRadian), math.sin(startRadian));
    final startLineFrom = center + startLineDirection * spec.innerRadius;
    final startLineTo = startLineFrom + startLineDirection * sectionRadius;
    return Line(startLineFrom, startLineTo);
  }

  /// 线段，起点为内环点，终点为外环点
  Line _endLine(int index, Offset center, double sectionRadius) {
    final endRadian = calculator.endRadian(index);
    final endLineDirection = Offset(math.cos(endRadian), math.sin(endRadian));
    final endLineFrom = center + endLineDirection * spec.innerRadius;
    final endLineTo = endLineFrom + endLineDirection * sectionRadius;
    return Line(endLineFrom, endLineTo);
  }

  void _updateSelectedSection(int index, List<PieSection> data) {
    if (selectedIndex == index) return;

    selectedIndex = index;
    sectionSelectedCallBack?.call(data[index], index);
    _updateUIWithAnimation();
  }

  void _updateUIWithAnimation() {
    _controller?.reset();
    _controller?.forward();
  }

  void _updateExpandSectionUI() {
    calculator.currentExpandRadius = _animation?.value ?? spec.outerExpandRadius;
    update();
  }

  void _resetCalculatorAndAnimation() {
    _animation?.removeListener(_updateExpandSectionUI);
    if (_controller != null) {
      _animation = Tween(
        begin: spec.outerRadius,
        end: spec.outerExpandRadius,
      ).animate(_controller!)
        ..addListener(_updateExpandSectionUI);
    }
  }
}
