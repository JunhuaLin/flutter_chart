import 'package:date_format/date_format.dart';

/// FileName date_formate
///
/// @Author jingweixie
/// @Date 2024/3/21
/// @Description 日期格式化工具

const int _secondToMill = 1000;

const List<String> dayMonthYear = [dd, '/', mm, '/', yyyy];

const List<String> monthYear = [mm, '/', yyyy];

const List<String> monthDay = [mm, '/', dd];

const List<String> hourMinute = [HH, ':', nn];

const List<String> hourMinuteSecond = [HH, ':', nn, ':', ss];

class DateFormatUtil {
  static String formatDateToDayMonthYearByValue(
    int value, {
    int valueRadio = _secondToMill,
    List<String> formats = dayMonthYear,
  }) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(value * valueRadio);
    return formatDate(dateTime, formats);
  }
}
