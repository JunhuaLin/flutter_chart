import 'package:flutter/widgets.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName pie_chart_example1
///
/// @Author junhua
/// @Date 2024/3/19
class PieChartSample1 extends StatelessWidget {
  const PieChartSample1({super.key});

  final List<PieSection> dataSet = const [
    PieSection(26506.0, "科技"),
    PieSection(17641.0, "金融服务"),
    PieSection(15616.0, "医疗保健"),
    PieSection(10860.0, "工业"),
    PieSection(9593.0, "电信服务"),
    PieSection(7058.0, "周期性消费"),
    PieSection(5313.0, "防守性消费"),
    PieSection(4705.0, "能源"),
    PieSection(2446.0, "公用事业"),
    PieSection(262.0, "基础材料"),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PieChart(
          DataSet(dataSet),
          height: 100.px,
          width: 100.px,
          enableTap: true,
          spec: PieSpec(
            innerRadius: 0.px,
            outerRadius: 50.px,
            outerExpandRadius: 70.px,
          ),
          onTapDownCallBack: (index) => debugPrint("chart.pie pressCallback $index"),
        ),
      ),
    );
  }
}
