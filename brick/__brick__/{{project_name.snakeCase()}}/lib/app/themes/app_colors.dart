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

  /// Light [ColorScheme] made with FlexColorScheme v8.0.0.
  /// Requires Flutter 3.22.0 or later.
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff1565c0),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xff90caf9),
    onPrimaryContainer: Color(0xff000000),
    primaryFixed: Color(0xffc5dcf7),
    primaryFixedDim: Color(0xff95bde9),
    onPrimaryFixed: Color(0xff072649),
    onPrimaryFixedVariant: Color(0xff092f59),
    secondary: Color(0xff039be5),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffcbe6ff),
    onSecondaryContainer: Color(0xff000000),
    secondaryFixed: Color(0xffc2eafe),
    secondaryFixedDim: Color(0xff8dd5f8),
    onSecondaryFixed: Color(0xff013f5d),
    onSecondaryFixedVariant: Color(0xff014b6f),
    tertiary: Color(0xff0277bd),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffbedcff),
    onTertiaryContainer: Color(0xff000000),
    tertiaryFixed: Color(0xffbfe3f8),
    tertiaryFixedDim: Color(0xff8cc8ec),
    onTertiaryFixed: Color(0xff002941),
    onTertiaryFixedVariant: Color(0xff003452),
    error: Color(0xffb00020),
    onError: Color(0xffffffff),
    errorContainer: Color(0xfffcd8df),
    onErrorContainer: Color(0xff000000),
    surface: Color(0xfffcfcfc),
    onSurface: Color(0xff111111),
    surfaceDim: Color(0xffe0e0e0),
    surfaceBright: Color(0xfffdfdfd),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff8f8f8),
    surfaceContainer: Color(0xfff3f3f3),
    surfaceContainerHigh: Color(0xffededed),
    surfaceContainerHighest: Color(0xffe7e7e7),
    onSurfaceVariant: Color(0xff393939),
    outline: Color(0xff919191),
    outlineVariant: Color(0xffd1d1d1),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2a2a2a),
    onInverseSurface: Color(0xfff1f1f1),
    inversePrimary: Color(0xffaedfff),
    surfaceTint: Color(0xff1565c0),
  );

  /// Dark [ColorScheme] made with FlexColorScheme v8.0.0.
  /// Requires Flutter 3.22.0 or later.
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff90caf9),
    onPrimary: Color(0xff000000),
    primaryContainer: Color(0xff0d47a1),
    onPrimaryContainer: Color(0xffffffff),
    primaryFixed: Color(0xffc5dcf7),
    primaryFixedDim: Color(0xff95bde9),
    onPrimaryFixed: Color(0xff072649),
    onPrimaryFixedVariant: Color(0xff092f59),
    secondary: Color(0xff81d4fa),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xff004b73),
    onSecondaryContainer: Color(0xffffffff),
    secondaryFixed: Color(0xffc2eafe),
    secondaryFixedDim: Color(0xff8dd5f8),
    onSecondaryFixed: Color(0xff013f5d),
    onSecondaryFixedVariant: Color(0xff014b6f),
    tertiary: Color(0xffe1f5fe),
    onTertiary: Color(0xff000000),
    tertiaryContainer: Color(0xff1a567d),
    onTertiaryContainer: Color(0xffffffff),
    tertiaryFixed: Color(0xffbfe3f8),
    tertiaryFixedDim: Color(0xff8cc8ec),
    onTertiaryFixed: Color(0xff002941),
    onTertiaryFixedVariant: Color(0xff003452),
    error: Color(0xffcf6679),
    onError: Color(0xff000000),
    errorContainer: Color(0xffb1384e),
    onErrorContainer: Color(0xffffffff),
    surface: Color(0xff080808),
    onSurface: Color(0xfff1f1f1),
    surfaceDim: Color(0xff060606),
    surfaceBright: Color(0xff2c2c2c),
    surfaceContainerLowest: Color(0xff010101),
    surfaceContainerLow: Color(0xff0e0e0e),
    surfaceContainer: Color(0xff151515),
    surfaceContainerHigh: Color(0xff1d1d1d),
    surfaceContainerHighest: Color(0xff282828),
    onSurfaceVariant: Color(0xffcacaca),
    outline: Color(0xff777777),
    outlineVariant: Color(0xff414141),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe8e8e8),
    onInverseSurface: Color(0xff2a2a2a),
    inversePrimary: Color(0xff435a6a),
    surfaceTint: Color(0xff90caf9),
  );
}
