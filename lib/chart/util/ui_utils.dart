import 'package:flutter/material.dart';

/// FileName ui_utils
///
/// @Author junhua
/// @Date 2024/3/18
/// 常用ui的工具类方法
class UiUtils {
  /// 字体缩放大小
  static double textScaleFactor = 1;

  /// 获取文字的宽度的缩放的方法
  static double Function(double size) pxTransformFunc = (size) => size;

  static double calculateTextWidth(String? text, TextStyle style) {
    // Text size disallow text scale,
    // so the text painter width need to be multiplied by text scale factor.
    return _layoutTextPainter(text, style).width * textScaleFactor;
  }

  static double calculateTextHeight(String text, TextStyle style) {
    // Text size disallow text scale,
    // so the text painter height need to be multiplied by text scale factor.
    return _layoutTextPainter(text, style).height * textScaleFactor;
  }

  static TextPainter _layoutTextPainter(
    String? text,
    TextStyle style, {
    double maxWidth = double.infinity,
  }) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(text: text, style: style);
    textPainter.layout(maxWidth: maxWidth);
    return textPainter;
  }
}

extension UiExtension on num {
  double get px => UiUtils.pxTransformFunc(toDouble());
}
