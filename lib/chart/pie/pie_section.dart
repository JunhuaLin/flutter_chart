import 'package:equatable/equatable.dart';

/// 饼图数据结构
///
/// @Author theonlin
/// @Date 2023-11-27
class PieSection extends Equatable {
  const PieSection(
    this.value,
    this.title,
  );

  /// 它决定在圆周围占据多少空间及图例占比
  final double value;

  /// 图例名
  final String? title;

  @override
  List<Object?> get props => [
        value,
        title,
      ];

  @override
  String toString() {
    return 'PieSection{value: $value, title: $title}';
  }
}
