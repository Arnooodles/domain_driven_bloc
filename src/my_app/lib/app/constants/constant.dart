import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final class Constant {
  static const String appName = 'Very Good Core';
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1200;
  static const String networkLookup = 'www.google.com';
  static const String baseUrl = 'https://dummyjson.com';
  static const List<LocalizationsDelegate<dynamic>> localizationDelegates = <LocalizationsDelegate<dynamic>>[
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(seconds: 1);
  static const Duration longDelay = Duration(seconds: 5);
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const int defaultPaginationLimit = 20;
}
