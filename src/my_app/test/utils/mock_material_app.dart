import 'package:flutter/material.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/app/themes/app_theme.dart';

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
