import 'package:example/menu/menu_row.dart';
import 'package:example/resources/app_assets.dart';
import 'package:example/resources/app_colors.dart';
import 'package:example/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FileName app_menu
///
/// @Author junhua
/// @Date 2024/3/18
/// app菜单
class AppMenu extends StatefulWidget {
  final List<ChartMenuItem> menuItems;
  final int currentSelectIndex;
  final Function(int, ChartMenuItem) onItemSelected;

  const AppMenu({
    Key? key,
    required this.menuItems,
    required this.currentSelectIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.itemsBackground,
      child: Column(
        children: [
          SafeArea(
              child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              InkWell(
                child: SvgPicture.asset(
                  AppAssets.flChartLogoText,
                ),
              ),
            ],
          )),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                final menuItem = widget.menuItems[position];
                return MenuRow(
                    text: menuItem.text,
                    svgPath: menuItem.iconPath,
                    isSelected: widget.currentSelectIndex == position,
                    onTap: () {
                      widget.onItemSelected(position, menuItem);
                    });
              },
              itemCount: widget.menuItems.length,
            ),
          ),
        ],
      ),
    );
  }
}

/// app菜单
class ChartMenuItem {
  final ChartType chartType;
  final String text;
  final String iconPath;

  const ChartMenuItem(this.chartType, this.text, this.iconPath);
}
