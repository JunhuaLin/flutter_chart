/// @Description 用于x,y轴的基础数据结构
///
/// @Author junhua
/// @Date 2023/8/1
class Entry<T, D> {
  /// x方向数值
  T x;

  /// y方向数值
  D y;

  /// 是否是空白数据，用于填充位置，但不进行绘制，用于只需要显示前面某一段的数据，但是x轴比需要绘制的数据更长
  bool isBlank;

  /// 数据是否有效，有效则进行绘制，无效则不进行绘制
  bool get isValid => !isBlank;

  /// 数据是否无效，有效则进行绘制，无效则不进行绘制
  bool get isNotValid => isBlank;

  Entry(this.x, this.y, {this.isBlank = false});

  @override
  String toString() {
    return 'Entry{x: $x, y: $y}';
  }
}
