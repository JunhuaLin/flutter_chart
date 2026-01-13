import 'package:example/resources/app_dimens.dart';
import 'package:example/sample/chart_samples.dart';
import 'package:example/util/app_helper.dart';
import 'package:example/widgets/chart_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// FileName chart_sample_widget
///
/// @Author junhua
/// @Date 2024/3/18
/// chart的页面样式
class ChartSamplesPage extends StatelessWidget {
  final ChartType chartType;

  final samples = ChartSamples.samples;

  ChartSamplesPage({
    Key? key,
    required this.chartType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MasonryGridView.builder(
        key: ValueKey(chartType),
        itemCount: samples[chartType]!.length,
        padding: const EdgeInsets.only(
          left: AppDimens.chartSamplesSpace,
          right: AppDimens.chartSamplesSpace,
          top: AppDimens.chartSamplesSpace,
          bottom: AppDimens.chartSamplesSpace + 68,
        ),
        crossAxisSpacing: AppDimens.chartSamplesSpace,
        mainAxisSpacing: AppDimens.chartSamplesSpace,
        gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 600,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ChartHolder(chartSample: samples[chartType]![index]);
        },
      ),
    );
  }
}
