import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// @Description 十字针特性
///
/// @Author junhua
/// @Date 2023/8/2
class CrossStitchSpec extends Equatable {
  /// 十字针外环颜色
  final Color stitchCircleOuterColor;

  /// 十字针内环颜色
  final Color stitchCircleInnerColor;

  /// 十字针中心环画笔宽度
  final double stitchCircleLineWidth;

  /// 画十字针的横线
  final bool showStitchHorLine;

  /// 画十字针的竖线
  final bool showStitchVerLine;

  /// 十字针中心内环半径
  final double stitchInnerCircle;

  /// 十字针中心外环半径
  final double stitchOuterCircle;

  /// 十字针显示中心环
  final bool showStitchCircle;

  /// 十字针颜色
  final Color stitchLineColor;

  ///  十字针宽度
  final double stitchLineWidth;

  ///  十字针标签颜色
  final Color labelBackGroundColor;

  /// 标签圆角
  final double labelBackgroundRadius;

  ///  十字针标签字体样式, 距离background
  final TextStyle labelTextStyle;

  /// 十字针文字margin
  final EdgeInsets labelPadding;

  /// 十字针label margin, 距离外边界
  final EdgeInsets labelMargin;

  /// 是否显示y轴标签
  final bool showYLabel;

  /// 是否显示x轴标签
  final bool showXLabel;

  const CrossStitchSpec({
    this.stitchCircleOuterColor = const Color(0xFF0095FF),
    this.stitchCircleInnerColor = Colors.white,
    this.stitchCircleLineWidth = 2,
    this.stitchInnerCircle = 2,
    this.stitchOuterCircle = 4,
    this.showStitchCircle = false,
    this.stitchLineColor = const Color(0xFFADADAD),
    this.stitchLineWidth = 1,
    this.labelBackGroundColor = Colors.grey,
    this.labelTextStyle = const TextStyle(fontSize: 15, color: Colors.black),
    this.labelBackgroundRadius = 0,
    this.labelPadding = EdgeInsets.zero,
    this.labelMargin = EdgeInsets.zero,
    this.showStitchHorLine = true,
    this.showStitchVerLine = true,
    this.showYLabel = true,
    this.showXLabel = true,
  });

  @override
  List<Object?> get props =>
      [
        stitchCircleOuterColor,
        stitchCircleInnerColor,
        stitchCircleLineWidth,
        stitchInnerCircle,
        stitchOuterCircle,
        showStitchCircle,
        stitchLineColor,
        stitchLineWidth,
        labelBackGroundColor,
        labelTextStyle,
        labelBackgroundRadius,
        labelPadding,
        labelMargin,
        showStitchHorLine,
        showStitchVerLine,
        showYLabel,
        showXLabel,
      ];
}
