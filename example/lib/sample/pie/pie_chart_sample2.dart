import 'dart:math';

import 'package:example/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/util/ui_utils.dart';
import 'package:flutter_chart/flutter_chart.dart';

/// FileName pie_chart_example2
///
/// @Author junhua
/// @Date 2024/3/20
class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<PieChartSample2> createState() => _PieChartSample2State();
}

class _PieChartSample2State extends State<PieChartSample2> {
  List<PieSection> getDefaultPieData() {
    List<PieSection> dataSet = const [
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
    return dataSet;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _HorizontalLegendPieChart(
        dataSet: DataSet(getDefaultPieData()),
        legendListHeight: 200.px,
        spec: PieSpec(
          innerRadius: 30.px,
          outerRadius: 60.px,
          outerExpandRadius: 63.px,
          innerColor: AppColors.pageBackground,
          sectionSpace: 1.px,
        ),
      ),
    );
  }
}

typedef PercentageFormatterProvider = String Function(double percent);

class _HorizontalLegendPieChart extends StatefulWidget {
  _HorizontalLegendPieChart({
    Key? key,
    required this.dataSet,
    required this.legendListHeight,
    required this.spec,
    PercentageFormatterProvider? percentageFormatter,
  })  : percentageFormatter = percentageFormatter ?? ((percent) => percent.toStringAsFixed(2)),
        super(key: key);

  /// 饼图数据
  final DataSet<PieSection> dataSet;

  /// 图例列表高度
  final double legendListHeight;

  /// 饼图特性
  final PieSpec spec;

  /// 百分比格式化方法
  final PercentageFormatterProvider percentageFormatter;

  @override
  State<_HorizontalLegendPieChart> createState() => _HorizontalLegendPieChartState();
}

class _HorizontalLegendPieChartState extends State<_HorizontalLegendPieChart>
    with SingleTickerProviderStateMixin {
  /// 图例项高度
  static final double legendItemHeight = 30.px;

  /// 图例项间隙
  static final double legendItemSpace = 3.px;

  /// 图例选中项下标
  int _selectedIndex = 0;

  /// 是否隐藏图例底部遮罩
  bool _isShowBottomMark = true;

  final ScrollController _controller = ScrollController();
  late PieCalculator _calculator;

  @override
  void initState() {
    super.initState();

    _calculator = PieCalculator(widget.dataSet, widget.spec);
    _controller.addListener(() {
      bool isAtBottom = _controller.position.extentAfter > 0;
      if (isAtBottom != _isShowBottomMark) setState(() => _isShowBottomMark = isAtBottom);
    });
  }

  @override
  void didUpdateWidget(_HorizontalLegendPieChart oldWidget) {
    if (oldWidget.dataSet != widget.dataSet || oldWidget.spec != widget.spec) {
      _calculator = PieCalculator(widget.dataSet, widget.spec);
      _selectedIndex = 0;
      _controller.jumpTo(0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildPieChart(),
        SizedBox(width: 30.px),
        _buildLegendListArea(context),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      widget.dataSet,
      width: widget.spec.outerExpandRadius * 2,
      height: widget.spec.outerExpandRadius * 2,
      spec: widget.spec,
      enableTap: true,
      selectedIndex: _selectedIndex,
      onTapDownCallBack: (index) => _animateToSelectedLegend(index),
    );
  }

  Widget _buildLegendListArea(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: widget.legendListHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Stack(children: [
            _buildLegendList(context),
            if (_isShowBottomMark) _buildBottomMark(context),
          ]),
        ),
      ),
    );
  }

  Widget _buildBottomMark(BuildContext context) {
    return Positioned(
      bottom: 0.px,
      left: 0.px,
      right: 0.px,
      height: legendItemHeight + legendItemSpace,
      child: const IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.mainGridLineColor,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendList(BuildContext context) {
    return ListView.separated(
      controller: _controller,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.dataSet.data.length,
      separatorBuilder: (context, index) => SizedBox(height: legendItemSpace),
      itemBuilder: (context, index) => _buildLegendItem(context, index),
    );
  }

  Widget _buildLegendItem(BuildContext context, int index) {
    final pieSection = widget.dataSet.data[index];
    final sectionColor = widget.spec.sectionColor(index);
    final isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        height: legendItemHeight,
        padding: EdgeInsets.symmetric(vertical: 2.px, horizontal: 5.px),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainGridLineColor : null,
          borderRadius: BorderRadius.all(Radius.circular(12.px)),
        ),
        child: Row(
          children: [
            Container(
              width: 8.px,
              height: 8.px,
              decoration: BoxDecoration(
                color: sectionColor,
                borderRadius: BorderRadius.all(Radius.circular(4.px)),
              ),
            ),
            SizedBox(width: 10.px),
            Expanded(
              child: Text(
                pieSection.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.contentColorBlue,
                ),
              ),
            ),
            SizedBox(width: 5.px),
            Text(
              widget.percentageFormatter(_calculator.sectionPercentages[index]),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mainTextColor1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateToSelectedLegend(int index) {
    setState(() => _selectedIndex = index);

    // 最大可偏移距离
    var offset = max(0.0, _controller.position.extentTotal - widget.legendListHeight);
    // 若偏移超过了最大偏移距离，就取最大偏移距离
    offset = min(index * (legendItemHeight + legendItemSpace), offset);
    // 滚动到指定图例
    _controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}
