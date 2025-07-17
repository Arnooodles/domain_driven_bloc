import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/core/domain/bloc/app_localization/app_localization_bloc.dart';

extension BuildContextExt on BuildContext {
  I18n get i18n => read<AppLocalizationBloc>().state;

  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  bool get isDarkMode => theme.brightness == Brightness.dark;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  EdgeInsets get padding => MediaQuery.paddingOf(this);

  GoRouter get goRouter => GoRouter.of(this);

  NavigatorState get navigator => Navigator.of(this);
}
