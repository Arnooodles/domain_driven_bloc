import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';

class MockMaterialApp extends StatelessWidget {
  const MockMaterialApp({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: child,
    title: Constant.appName,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    localizationsDelegates: Constant.localizationDelegates,
    supportedLocales: AppLocaleUtils.supportedLocales,
    debugShowCheckedModeBanner: false,
  );
}
