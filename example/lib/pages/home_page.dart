import 'package:dartx/dartx.dart';
import 'package:example/menu/app_menu.dart';
import 'package:example/pages/chart_sample_widget.dart';
import 'package:example/resources/app_dimens.dart';
import 'package:example/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// FileName home_page
///
/// @Author junhua
/// @Date 2024/3/18
/// 主页
class HomePage extends StatefulWidget {
  ChartType showingChartType;

  HomePage({
    Key? key,
    required this.showingChartType,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Map<ChartType, int> _menuItemsIndices;
  late final List<ChartMenuItem> _menuItems;

  /// 显示性能数据
  bool showPerformance = false;

  @override
  initState() {
    super.initState();
    _initMenuItems();
  }

  void _initMenuItems() {
    _menuItemsIndices = {};
    _menuItems = ChartType.values.mapIndexed((
      int index,
      ChartType type,
    ) {
      _menuItemsIndices[type] = index;
      return ChartMenuItem(
        type,
        type.displayName,
        type.assetIcon,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMenuIndex = _menuItemsIndices[widget.showingChartType]!;
    return LayoutBuilder(builder: (context, constraints) {
      final needsDrawer =
          constraints.maxWidth <= AppDimens.menuMaxNeededWidth + AppDimens.chartBoxMinWidth;
      final appMenuWidget = AppMenu(
        menuItems: _menuItems,
        currentSelectIndex: selectedMenuIndex,
        onItemSelected: (newIndex, chartMenuItem) {
          context.go('/${chartMenuItem.chartType.name}');
          if (needsDrawer) {
            Navigator.of(context).pop();
          }
        },
      );
      final samplesSectionWidget = ChartSamplesPage(
        chartType: widget.showingChartType,
      );
      final body = needsDrawer
          ? samplesSectionWidget
          : Row(
              children: [
                SizedBox(
                  width: AppDimens.menuMaxNeededWidth,
                  child: appMenuWidget,
                ),
                Expanded(
                  child: samplesSectionWidget,
                ),
              ],
            );

      return Scaffold(
        body: body,
        drawer: needsDrawer ? Drawer(child: appMenuWidget) : null,
        appBar: needsDrawer
            ? AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(widget.showingChartType.displayName),
              )
            : null,
      );
    });
  }
}
