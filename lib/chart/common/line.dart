import 'dart:math' as math;
import 'dart:ui';

/// 描述直线模型（包含 [from] 和 [to]）
///
/// @Author theonlin
/// @Date 2023-11-27
class Line {
  const Line(this.from, this.to);

  /// 开始点
  final Offset from;

  /// 结束点
  final Offset to;

  /// 线长（勾股定理）
  double get length {
    final diff = to - from;
    final dx = diff.dx;
    final dy = diff.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// 返回以弧度为单位的角度
  double get direction {
    final diff = to - from;
    return math.atan(diff.dy / diff.dx);
  }

  /// 返回线长为 1.0 的偏移量
  Offset get normalize {
    final diff = to - from;
    return diff * (1.0 / length);
  }

  /// 返回以 chart.line 为中心，长度为 [width] 的矩形路径
  Path createRectPathAroundLine(double width) {
    width = width / 2;
    final normalized = normalize;
    final verticalAngle = direction + (math.pi / 2);
    final verticalDirection = Offset(math.cos(verticalAngle), math.sin(verticalAngle));

    final startPoint1 = Offset(
      from.dx - (normalized * (width / 2)).dx - (verticalDirection * width).dx,
      from.dy - (normalized * (width / 2)).dy - (verticalDirection * width).dy,
    );

    final startPoint2 = Offset(
      to.dx + (normalized * (width / 2)).dx - (verticalDirection * width).dx,
      to.dy + (normalized * (width / 2)).dy - (verticalDirection * width).dy,
    );

    final startPoint3 = Offset(
      startPoint2.dx + (verticalDirection * (width * 2)).dx,
      startPoint2.dy + (verticalDirection * (width * 2)).dy,
    );

    final startPoint4 = Offset(
      startPoint1.dx + (verticalDirection * (width * 2)).dx,
      startPoint1.dy + (verticalDirection * (width * 2)).dy,
    );

    return Path()
      ..moveTo(startPoint1.dx, startPoint1.dy)
      ..lineTo(startPoint2.dx, startPoint2.dy)
      ..lineTo(startPoint3.dx, startPoint3.dy)
      ..lineTo(startPoint4.dx, startPoint4.dy)
      ..lineTo(startPoint1.dx, startPoint1.dy);
  }
}
