import 'dart:math';
import 'dart:ui';

/// FileName dash_painter
///
/// @Author junhua
/// @Date 2023/11/17
/// 虚线的画笔
class DashPainter {
  /// 虚线的长度
  final double dashWidth;

  /// 虚线的间隔
  final double dashSpan;

  const DashPainter({
    this.dashWidth = 2,
    this.dashSpan = 2,
  });

  double get partLength => dashWidth + dashSpan;

  void draw(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pms = path.computeMetrics();
    for (var pm in pms) {
      final int count = pm.length ~/ partLength;
      for (int i = 0; i < count; i++) {
        canvas.drawPath(pm.extractPath(partLength * i, partLength * i + dashWidth), paint);
      }
      final double tail = pm.length % partLength;
      canvas.drawPath(
          pm.extractPath(pm.length - tail, min(pm.length - tail + dashWidth, pm.length - tail)),
          paint);
    }
  }
}
