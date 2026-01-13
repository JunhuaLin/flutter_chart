import 'package:example/resources/app_colors.dart';
import 'package:example/resources/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FileName menu_row
///
/// @Author junhua
/// @Date 2024/3/18
/// 菜单行
class MenuRow extends StatefulWidget {
  final String text;
  final String svgPath;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuRow({
    Key? key,
    required this.text,
    required this.svgPath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<MenuRow> {
  bool get _showSelectedState => widget.isSelected;

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        child: SizedBox(
          height: AppDimens.menuRowHeight,
          child: Row(children: [
            const SizedBox(
              width: 36,
            ),
            SvgPicture.asset(
              widget.svgPath,
              width: AppDimens.menuIconSize,
              height: AppDimens.menuIconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              widget.text,
              style: TextStyle(
                color: _showSelectedState ? AppColors.primary : Colors.white,
                fontSize: AppDimens.menuTextSize,
              ),
            ),
            Expanded(child: Container()),
            const SizedBox(
              width: 18,
            ),
          ]),
        ),
      ),
    );
  }
}
