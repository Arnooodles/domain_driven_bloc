import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:very_good_core/app/config/scroll_behavior_config.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/generated/l10n.dart';
import 'package:very_good_core/app/helpers/injection.dart';
import 'package:very_good_core/app/routes/app_router.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppRouter _appRouter = getIt<AppRouter>(param1: getIt<AuthBloc>());

  final List<BlocProvider<dynamic>> _providers = <BlocProvider<dynamic>>[
    BlocProvider<AppCoreBloc>(
      create: (BuildContext context) => getIt<AppCoreBloc>(),
    ),
    BlocProvider<AuthBloc>(
      create: (BuildContext context) => getIt<AuthBloc>(),
    ),
    BlocProvider<ThemeBloc>(
      create: (BuildContext context) => getIt<ThemeBloc>(),
    ),
    BlocProvider<AppLifeCycleBloc>(
      create: (BuildContext context) => getIt<AppLifeCycleBloc>(),
    ),
  ];

  final List<ResponsiveBreakpoint> _breakpoints = <ResponsiveBreakpoint>[
    const ResponsiveBreakpoint.autoScaleDown(
      Constant.mobileBreakpoint,
      name: PHONE,
    ),
    const ResponsiveBreakpoint.resize(
      Constant.mobileBreakpoint,
      name: MOBILE,
    ),
    const ResponsiveBreakpoint.resize(
      Constant.tabletBreakpoint,
      name: TABLET,
    ),
    const ResponsiveBreakpoint.resize(
      Constant.desktopBreakpoint,
      name: DESKTOP,
    ),
  ];

  final List<LocalizationsDelegate<dynamic>> _localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: _providers,
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (BuildContext context, ThemeMode themeMode) =>
              MaterialApp.router(
            routerConfig: _appRouter.router,
            builder: (BuildContext context, Widget? child) =>
                ResponsiveWrapper.builder(
              child,
              minWidth: Constant.mobileBreakpoint,
              breakpoints: _breakpoints,
            ),
            title: Constant.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            localizationsDelegates: _localizationsDelegates,
            supportedLocales: AppLocalizations.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            scrollBehavior: ScrollBehaviorConfig(),
          ),
        ),
      );
}
