import 'package:example/resources/app_colors.dart';
import 'package:example/resources/app_dimens.dart';
import 'package:example/sample/chart_sample.dart';
import 'package:flutter/material.dart';

/// FileName chart_holder
///
/// @Author jingweixie
/// @Date 2024/3/19
/// 图表容器
class ChartHolder extends StatelessWidget {
  final ChartSample chartSample;

  const ChartHolder({
    Key? key,
    required this.chartSample,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 6,
            ),
            Text(
              chartSample.name,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.itemsBackground,
            borderRadius: BorderRadius.all(Radius.circular(AppDimens.defaultRadius)),
          ),
          child: chartSample.builder(context),
        )
      ],
    );
  }
}
