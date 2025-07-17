import 'package:flutter/material.dart';

sealed class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  /// Default colors for shimmer
  static const Color lightShimmerHighlight = Color(0xffE6E8EB);
  static const Color darkShimmerHighlight = Color(0xff2A2C2E);
  static const Color lightShimmerBase = Color(0xffF9F9FB);
  static const Color darkShimmerBase = Color(0xff3A3E3F);

  /// Text url default color
  static const Color defaultTextUrl = Colors.lightBlue;
  static const Color defaultBoxShadow = Color(0x1F000000);
  static const Color seedColor = Color(0xFF0061A4);

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: seedColor,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  );
}
