import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final class Constant {
  static const String appName = '{{project_name.titleCase()}}';
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1200;
  static const String networkLookup = 'www.google.com';
  static const List<LocalizationsDelegate<dynamic>> localizationDelegates =
      <LocalizationsDelegate<dynamic>>[
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}
