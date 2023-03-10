import 'package:flutter/material.dart';
import 'package:very_good_core/app/themes/app_colors.dart';
import 'package:very_good_core/app/themes/text_styles.dart';

abstract class AppTheme {
  /// Standard `ThemeData` for App UI.
  static ThemeData get _baseTheme => ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: _textTheme,
      );

  static ThemeData get lightTheme => _baseTheme.copyWith(
        colorScheme: AppColors.lightColorScheme,
      );

  static ThemeData get darkTheme => _baseTheme.copyWith(
        colorScheme: AppColors.darkColorScheme,
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: AppTextStyle.displayLarge,
        displayMedium: AppTextStyle.displayMedium,
        displaySmall: AppTextStyle.displaySmall,
        headlineLarge: AppTextStyle.headlineLarge,
        headlineMedium: AppTextStyle.headlineMedium,
        headlineSmall: AppTextStyle.headlineSmall,
        titleLarge: AppTextStyle.titleLarge,
        titleMedium: AppTextStyle.titleMedium,
        titleSmall: AppTextStyle.titleSmall,
        bodyLarge: AppTextStyle.bodyLarge,
        bodyMedium: AppTextStyle.bodyMedium,
        bodySmall: AppTextStyle.bodySmall,
        labelLarge: AppTextStyle.labelLarge,
        labelMedium: AppTextStyle.labelMedium,
        labelSmall: AppTextStyle.labelSmall,
      );

  static const double defaultRadius = 16;
  static const double defaultNavBarHeight = 80;
  static final double defaultAppBarHeight = AppBar().preferredSize.height;
  static final BorderRadius defaultBoardRadius =
      BorderRadius.circular(defaultRadius);
}
