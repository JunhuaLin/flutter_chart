import 'dart:math';

import 'package:example/resources/app_colors.dart';
import 'package:example/sample/candle/common_candle_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName candle_sample1
///
/// @Author junhua
/// @Date 2024/3/21
class CandleChartSample1 extends StatefulWidget {
  const CandleChartSample1({super.key});

  @override
  State<CandleChartSample1> createState() => _CandleChartSample1State();
}

class _CandleChartSample1State extends State<CandleChartSample1> {
  bool _isHollow = false;

  /// 十字针选择的entry
  final ValueNotifier<CandleEntry?> _selectNotifier = ValueNotifier<CandleEntry?>(null);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 4,
                bottom: 4,
              ),
              child: CommonCandleChart(_buildStickChartData(1000),
                  isGreenHollow: _isHollow,
                  isRedHollow: _isHollow, onLongPressCallback: OnLongPressCallback(
                onLongPress: (entry, index) {
                  _selectNotifier.value = entry;
                },
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
            child: Row(
              children: [
                Checkbox(
                  value: _isHollow,
                  onChanged: (value) {
                    setState(() {
                      _isHollow = value!;
                    });
                  },
                ),
                const Text(
                  '是否空心',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mainTextColor2,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '选中数据的index值',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mainTextColor2,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ValueListenableBuilder<CandleEntry?>(
                  valueListenable: _selectNotifier,
                  builder: (BuildContext context, CandleEntry? value, Widget? child) => value ==
                          null
                      ? const Spacer()
                      : Text(
                          value.x.toString(),
                          style: const TextStyle(fontSize: 15, color: AppColors.contentColorBlue),
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  CandleStickChartData _buildStickChartData(int randomNumber) {
    List<CandleEntry> candleData = [];

    double offset = 30;
    for (int i = 0; i < randomNumber; i++) {
      double open = Random().nextDouble() * 100;
      double close = Random().nextDouble() * 100;
      double high = max(open, close) * 1.2;
      double low = min(open, close) * 0.75;
      double volume = -Random().nextDouble() * 100 + 50;
      candleData
          .add(CandleEntry(open + offset, close + offset, high + offset, low + offset, volume, i));
    }

    return CandleStickChartData(candleData)..displayCount = 30;
  }
}
