import 'package:example/resources/app_colors.dart';
import 'package:example/util/date_formate.dart';
import 'package:example/util/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName bar_chart_example1
///
/// @Author junhua
/// @Date 2024/3/21
class BarChartSample1 extends StatefulWidget {
  const BarChartSample1({super.key});

  @override
  State<BarChartSample1> createState() => _BarChartSample1State();
}

class _BarChartSample1State extends State<BarChartSample1> {
  List<NetAsset> netAssets = [
    NetAsset(
      1698681600,
      355171027,
    ),
    NetAsset(
      1701273600,
      743903942,
    ),
    NetAsset(
      1703779200,
      872244840,
    ),
    NetAsset(
      1706630400,
      827571093,
    ),
    NetAsset(
      1709136000,
      820710301,
    ),
    NetAsset(
      1710777600,
      624234650,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Horizontal Bar',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 6),
                child: _BartChart(netAssets),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class _BartChart extends StatelessWidget {
  final List<NetAsset> netAssets;

  const _BartChart(this.netAssets, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HorizontalBarChart(DataSet(netAssets),
        xAxisLabelProvider: (x, _, index) {
          return DateFormatUtil.formatDateToDayMonthYearByValue(x.toInt(), formats: monthYear);
        },
        xSecondaryAxisLabelProvider: (_, y, index) => NumUtils.formatWithUnit(y.toInt()),
        barSpec: HorizontalBarSpec(
          barWidth: 18.px,
          barMarginTop: 15.px,
          barColor: AppColors.primary,
          xAxisLabelStyle: const TextStyle(
            fontSize: 10,
            color: AppColors.mainTextColor1,
          ),
          xAxisLabelMargin: const EdgeInsets.only(top: 10),
          xSecondaryAxisLabelStyle: const TextStyle(
            fontSize: 10,
            color: AppColors.primary,
          ),
          xSecondaryAxisLabelMargin: EdgeInsets.only(top: 18.px),
          gridLineWidth: 1.px,
          gridLineColor: AppColors.mainGridLineColor,
          axisLineWidth: 2.px,
          axisLineColor: AppColors.mainGridLineColor,
          gridLindDashWidth: 2.px,
          gridLineDashSpan: 8.px,
        ));
  }
}

/// 资产规模item
class NetAsset extends Entry<num, num> {
  /// 资产值(精确到元)
  final int assetsValue;

  /// 日期（时间戳）
  final int datetime;

  NetAsset(
    this.datetime,
    this.assetsValue,
  ) : super(datetime, assetsValue);
}
