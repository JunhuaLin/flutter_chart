/// @Description 各个方向上的最小最大值
///
/// @Author junhua
/// @Date 2023/8/16
/// Holds minX, maxX, minY, and maxY for use in axis
class AxisMinMaxAxisValues {
  const AxisMinMaxAxisValues(
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  );

  /// x轴最小数据
  final double minX;

  /// x轴方向最大数据
  final double maxX;

  /// y轴最小数据
  final double minY;

  /// y轴最大数据
  final double maxY;
}
