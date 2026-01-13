import 'package:flutter_chart/chart/data/entry.dart';

/// FileName IValueProvider
///
/// @Author junhua
/// @Date 2024/4/1
/// @Description 值提供者
abstract class IValueProvider<T> {
  const IValueProvider();

  double getValue(T entry, int index);
}

/// 默认的值提供者，直接返回entry的值，用于同一个数据集中提供不同的值
class DefaultValueProvider<T extends Entry> implements IValueProvider<T> {
  const DefaultValueProvider();

  @override
  double getValue(T entry, int index) {
    return entry.y;
  }
}

typedef ValueProvider<T> = double Function(T entry, int index);
