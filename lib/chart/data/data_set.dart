import 'package:equatable/equatable.dart';

/// @Description 数据基础类集合
///
/// @Author junhua
/// @Date 2023/8/1
class DataSet<D> extends Equatable {
  /// 列表数据
  final List<D> data;

  const DataSet(this.data);

  @override
  List<Object?> get props => [data];
}
