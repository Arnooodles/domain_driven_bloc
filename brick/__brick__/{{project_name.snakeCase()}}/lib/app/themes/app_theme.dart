import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_text_style.dart';

sealed class AppTheme {
  /// Standard `ThemeData` for App UI.
  static final ThemeData light = _buildThemeData(AppColors.lightColorScheme);
  static final ThemeData dark = _buildThemeData(AppColors.darkColorScheme);

  static final TextTheme _textTheme = TextTheme(
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

  // Common border radius, independent of color scheme
  static const double defaultRadius = AppSizes.radiusLarge;
  static const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(defaultRadius));
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(AppSizes.xLarge));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(AppSizes.radiusFull));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(AppSizes.radiusLarge));

  static const double defaultNavBarHeight = 80;
  static final double defaultAppBarHeight = AppBar().preferredSize.height;

  static const List<BoxShadow> defaultBoxShadow = <BoxShadow>[
    BoxShadow(color: AppColors.defaultBoxShadow, offset: Offset(0, 6), blurRadius: 16),
  ];

  static ThemeData _buildThemeData(ColorScheme colorScheme) {
    // Component themes that are dependent on the color scheme
    final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        shape: const RoundedRectangleBorder(borderRadius: buttonBorderRadius),
        padding: EdgeInsets.zero,
        elevation: 2,
        shadowColor: colorScheme.scrim,
        textStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: AppFontWeight.semiBold),
      ),
    );

    final OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        textStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: AppFontWeight.semiBold),
        foregroundColor: colorScheme.onSurface,
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLarge))),
      ),
    );

    final FilledButtonThemeData filledButtonTheme = FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: const RoundedRectangleBorder(borderRadius: buttonBorderRadius),
        elevation: 0,
        padding: EdgeInsets.zero,
        textStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: AppFontWeight.semiBold),
      ),
    );

    final TextButtonThemeData textButtonTheme = TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: const RoundedRectangleBorder(borderRadius: buttonBorderRadius),
        padding: EdgeInsets.zero,
        textStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: AppFontWeight.semiBold),
      ),
    );

    final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      border: const OutlineInputBorder(borderRadius: inputBorderRadius, borderSide: BorderSide.none),
      enabledBorder: const OutlineInputBorder(borderRadius: inputBorderRadius, borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.medium, vertical: AppSizes.small),
      hintStyle: AppTextStyle.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
    );

    final CardThemeData cardTheme = CardThemeData(
      color: colorScheme.surfaceContainer,
      elevation: 1,
      shadowColor: colorScheme.shadow,
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      margin: const EdgeInsets.all(AppSizes.xSmall),
    );

    final AppBarTheme appBarTheme = AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 1,
      shadowColor: colorScheme.shadow,
      centerTitle: true,
      titleTextStyle: AppTextStyle.titleLarge.copyWith(
        color: colorScheme.onSurface,
        fontWeight: AppFontWeight.semiBold,
      ),
    );

    final BottomNavigationBarThemeData bottomNavigationBarTheme = BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 1,
      selectedLabelStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: AppFontWeight.medium),
      unselectedLabelStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: AppFontWeight.regular),
    );

    final TabBarThemeData tabBarTheme = TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorColor: colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: AppTextStyle.labelMedium.copyWith(fontWeight: AppFontWeight.semiBold),
      unselectedLabelStyle: AppTextStyle.labelMedium.copyWith(fontWeight: AppFontWeight.regular),
    );

    final DividerThemeData dividerTheme = DividerThemeData(
      color: colorScheme.outline,
      thickness: 1,
      space: AppSizes.medium,
    );

    // The base theme
    return ThemeData(
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: _textTheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // Component themes
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      textButtonTheme: textButtonTheme,
      filledButtonTheme: filledButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      cardTheme: cardTheme,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      tabBarTheme: tabBarTheme,
      dividerTheme: dividerTheme,
    );
  }
}
