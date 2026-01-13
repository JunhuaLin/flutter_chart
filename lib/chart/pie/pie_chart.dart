import 'package:flutter_chart/chart/behavior/behavior_callback.dart';
import 'package:flutter_chart/chart/core/base_chart.dart';
import 'package:flutter_chart/chart/data/data_set.dart';
import 'package:flutter_chart/chart/pie/pie_calculator.dart';
import 'package:flutter_chart/chart/pie/pie_render.dart';
import 'package:flutter_chart/chart/pie/pie_section.dart';
import 'package:flutter_chart/chart/pie/pie_spec.dart';

/// 饼图图表
///
/// 注意：内部 [dataSet] 不会排序处理，若需要排序，请在外部处理后传入
///
/// @Author theonlin
/// @Date 2023-11-27
class PieChart extends BaseChart<PieSection> {
  /// 支持点击
  final bool enableTap;

  const PieChart(
    this.dataSet, {
    required this.spec,
    required super.width,
    required super.height,
    this.onTapDownCallBack,
    this.selectedIndex = 0,
    this.enableTap = false,
    super.key,
    super.gestureManager,
  }) : super(dataSet);

  /// 饼图数据
  final DataSet<PieSection> dataSet;

  /// 饼图特性
  final PieSpec spec;

  /// 选中扇形索引
  final int selectedIndex;

  /// 点击的回调
  final OnTapDownCallback? onTapDownCallBack;

  @override
  _PieChartState createState() => _PieChartState();

  @override
  List<Object?> get chartProps => [
        chartData,
        spec,
        selectedIndex,
      ];
}

class _PieChartState extends BaseChartState<PieChart> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PieChart oldWidget) {
    var isDataChange = widget.dataSet != oldWidget.dataSet;
    _selectedIndex = isDataChange ? 0 : widget.selectedIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initRenderList() {
    PieRender pieRender = PieRender(
      PieCalculator(widget.dataSet, widget.spec),
      spec: widget.spec,
      selectedIndex: _selectedIndex,
      enableTap: widget.enableTap,
      sectionSelectedCallBack: (section, index) {
        _selectedIndex = index;
        widget.onTapDownCallBack?.call(index);
      },
    );
    registerRender(pieRender);
  }
}
