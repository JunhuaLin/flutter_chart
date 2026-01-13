import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:example/data/time_sharing_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName data_util
///
/// @Author jingweixie
/// @Date 2024/3/21
class DataUtil {
  static List<BarEntry> getRandomData({int count = 2500}) {
    List<BarEntry> dataSet = [];
    int step = 2;
    var random = Random();
    int randomNumber = 1000;
    for (int i = 0; i < count; i++) {
      var entry = BarEntry((i * step).toDouble(), random.nextInt(randomNumber).toDouble());
      dataSet.add(entry);
    }
    return dataSet;
  }

  /// 根据路径获取k线数据
  static Future<List<CandleEntry>> getCandleData(String path) {
    return rootBundle.loadString(path).then((value) {
      final parseJson = json.decode(value);
      final List<KLinePoint> candleList = (parseJson['klineItemList'] as List<dynamic>)
          .map<KLinePoint>((item) => KLinePoint(
              openPrice: double.tryParse(item['openPrice'] ?? ""),
              closePrice: double.tryParse(item['closePrice'] ?? ""),
              highestPrice: double.tryParse(item['highestPrice'] ?? ""),
              lowestPrice: double.tryParse(item['lowestPrice'] ?? ""),

              /// 这里使用成交额而不是成交量进行处理
              volume: double.tryParse(item['turnover'] ?? ""),
              tradeTime: int.parse(item['time'])))
          .toList();
      return candleList;
    });
  }

  /// 根据路径获取分时图数据
  static Future<TimeSharingDay> getTimeSharingData(String path) {
    return rootBundle.loadString(path).then((value) {
      final parseJson = json.decode(value);
      final List<TimeSharingDay> timeSharingDays = (parseJson['dayList'] as List<dynamic>)
          .map((e) => TimeSharingDay(
              double.tryParse(e['dayTime'] ?? "") ?? 0,
              (e['sectionList'] as List<dynamic>).map<SectionList>((item) {
                return SectionList(
                    selectionList: (item['pointList'] as List<dynamic>)
                        .map<TimeSharingPoint>((e) => TimeSharingPoint(
                              time: int.parse(e['time']),
                              close: double.tryParse(e['closePrice'] ?? "") ?? 0,
                              // 先使用开盘价代替均价，后续计算时再进行替换
                              average: double.tryParse(e['openPrice'] ?? "") ?? 0,
                              volume: double.tryParse(e['volume'] ?? "") ?? 0,
                              isBlank: e['closePrice'] == null,
                            ))
                        .toList(),
                    lastClosePrice: double.tryParse(item['lastClosePrice'] ?? "") ?? 0.0);
              }).toList()))
          .toList();
      return timeSharingDays.first;
    });
  }

  /// 根据路径获取分时图数据
  static Future<List<TickItemEntry>> getTickData(String path) {
    return rootBundle.loadString(path).then((value) {
      final parseJson = json.decode(value);
      final List<TickItemEntry> tickItemList = (parseJson['items'] as List<dynamic>)
          .map<TickItemEntry>((item) => TickItemEntry(
                price: double.tryParse(item['price'] ?? "") ?? 0,
                volume: double.tryParse(item['volume'] ?? "") ?? 0,
                exchangeDataTimeMs: int.tryParse(item['exchangeDataTimeMs'] ?? "") ?? 0,
                priceLastClose: double.tryParse(item['priceLastClose'] ?? "") ?? 0,
              ))
          .toList();
      return tickItemList;
    });
  }
}
