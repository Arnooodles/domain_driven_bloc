import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/text_styles.dart';

abstract class AppTheme {
  /// Standard `ThemeData` for App UI.
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: AppColors.lightColorScheme,
        textTheme: _textTheme,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: AppColors.darkColorScheme,
        textTheme: _textTheme,
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
  static final BorderRadius defaultBoardRadius =
      BorderRadius.circular(defaultRadius);
}
