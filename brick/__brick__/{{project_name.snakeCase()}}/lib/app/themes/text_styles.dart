import 'package:flutter/widgets.dart';

/// App Text Style Definitions
abstract class AppTextStyle {
  static const TextStyle _baseTextStyle = TextStyle(
    fontWeight: AppFontWeight.regular,
  );

  /// Display Large Text Style
  static TextStyle get displayLarge => _baseTextStyle.copyWith(
        fontSize: 57,
        fontWeight: AppFontWeight.regular,
        // height: 64,
      );

  /// Display Medium Text Style
  static TextStyle get displayMedium => _baseTextStyle.copyWith(
        fontSize: 45,
        fontWeight: AppFontWeight.regular,
        // height: 52,
      );

  /// Display Small Text Style
  static TextStyle get displaySmall => _baseTextStyle.copyWith(
        fontSize: 36,
        fontWeight: AppFontWeight.regular,
        // height: 44,
      );

  /// Headline Large Text Style
  static TextStyle get headlineLarge => _baseTextStyle.copyWith(
        fontSize: 32,
        fontWeight: AppFontWeight.regular,
        // height: 40,
      );

  /// Headline Medium Text Style
  static TextStyle get headlineMedium => _baseTextStyle.copyWith(
        fontSize: 28,
        fontWeight: AppFontWeight.regular,
        // height: 36,
      );

  /// Headline Small Text Style
  static TextStyle get headlineSmall => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: AppFontWeight.regular,
        // height: 32,
      );

  /// Title Large Text Style
  static TextStyle get titleLarge => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: AppFontWeight.regular,
        // height: 28,
      );

  /// Title Medium Text Style
  static TextStyle get titleMedium => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: AppFontWeight.medium,
        letterSpacing: 0.15,
        // height: 24,
      );

  /// Title Small Text Style
  static TextStyle get titleSmall => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: AppFontWeight.medium,
        letterSpacing: 0.1,
        // height: 20,
      );

  /// Label Large Text Style
  static TextStyle get labelLarge => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: AppFontWeight.medium,
        letterSpacing: 0.1,
        // height: 20,
      );

  /// Label Medium Text Style
  static TextStyle get labelMedium => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: AppFontWeight.medium,
        letterSpacing: 0.5,
        // height: 16,
      );

  /// Label Small Text Style
  static TextStyle get labelSmall => _baseTextStyle.copyWith(
        fontSize: 11,
        fontWeight: AppFontWeight.medium,
        letterSpacing: 0.5,
        // height: 16,
      );

  /// Body Large Text Style
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: AppFontWeight.regular,
        letterSpacing: 0.5,
        // height: 24,
      );

  /// Body Medium Text Style
  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: AppFontWeight.regular,
        letterSpacing: 0.25,
        // height: 20,
      );

  /// Body Small Text Style
  static TextStyle get bodySmall => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: AppFontWeight.regular,
        letterSpacing: 0.4,
        // height: 16,
      );
}

abstract class AppFontWeight {
  /// FontWeight value of `w900`
  static const FontWeight black = FontWeight.w900;

  /// FontWeight value of `w800`
  static const FontWeight extraBold = FontWeight.w800;

  /// FontWeight value of `w700`
  static const FontWeight bold = FontWeight.w700;

  /// FontWeight value of `w600`
  static const FontWeight semiBold = FontWeight.w600;

  /// FontWeight value of `w500`
  static const FontWeight medium = FontWeight.w500;

  /// FontWeight value of `w400`
  static const FontWeight regular = FontWeight.w400;

  /// FontWeight value of `w300`
  static const FontWeight light = FontWeight.w300;

  /// FontWeight value of `w200`
  static const FontWeight extraLight = FontWeight.w200;

  /// FontWeight value of `w100`
  static const FontWeight thin = FontWeight.w100;
}
