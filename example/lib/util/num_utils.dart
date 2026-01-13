import 'dart:math';

/// FileName num_utils
///
/// @Author jingweixie
/// @Date 2024/3/21
class NumUtils {
  /// 获取单位，中午是万、亿，英文是K、M、B，不足最小单位的返回空
  static String unit(num num) {
    if (num.abs() >= pow(10, 9)) return 'B';
    if (num.abs() >= pow(10, 6)) return 'M';
    if (num.abs() >= pow(10, 3)) return 'K';
    return '';
  }

  /// 格式化数字，有单位的保留2位小数
  static String format(num num) {
    if (num.abs() >= pow(10, 9)) return _numToString(num / pow(10, 9));
    if (num.abs() >= pow(10, 6)) return _numToString(num / pow(10, 6));
    if (num.abs() >= pow(10, 3)) return _numToString(num / pow(10, 3));
    return num.toString();
  }

  /// 保留[fractionDigits]位小数，截断处理
  static String _numToString(num num, {int fractionDigits = 2}) {
    String str = num.toString();
    int pointIndex = str.indexOf('.');
    while (pointIndex + fractionDigits >= str.length) {
      // 不足[fractionDigits]位小数的，往后面追加0
      str += '0';
    }
    return str.substring(0, pointIndex + fractionDigits + 1);
  }

  /// 格式化数字，并添加单位，如27.16亿
  static String formatWithUnit(num num) {
    return format(num) + unit(num);
  }
}
