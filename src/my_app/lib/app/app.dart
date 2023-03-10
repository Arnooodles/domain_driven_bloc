import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:very_good_core/app/config/scroll_behavior.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/generated/l10n.dart';
import 'package:very_good_core/app/routes/app_router.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/utils/injection.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  final GoRouter routerConfig =
      getIt<AppRouter>(param1: getIt<AuthBloc>()).router;

  @override
  Widget build(BuildContext context) {
    final List<BlocProvider<dynamic>> providers = <BlocProvider<dynamic>>[
      BlocProvider<AuthBloc>(
        create: (BuildContext context) => getIt<AuthBloc>(),
      ),
      BlocProvider<ThemeBloc>(
        create: (BuildContext context) => getIt<ThemeBloc>(),
      ),
      BlocProvider<AppLifeCycleBloc>(
        create: (BuildContext context) => getIt<AppLifeCycleBloc>(),
      ),
      BlocProvider<AppCoreBloc>(
        create: (BuildContext context) => getIt<AppCoreBloc>(),
      ),
    ];

    return MultiBlocProvider(
      providers: providers,
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (BuildContext context, ThemeMode themeMode) =>
            MaterialApp.router(
          routerConfig: routerConfig,
          builder: (BuildContext context, Widget? widget) =>
              ResponsiveWrapper.builder(
            widget,
            minWidth: Constant.mobileBreakpoint,
            breakpoints: const <ResponsiveBreakpoint>[
              ResponsiveBreakpoint.autoScaleDown(
                Constant.mobileBreakpoint,
                name: PHONE,
              ),
              ResponsiveBreakpoint.resize(
                Constant.mobileBreakpoint,
                name: MOBILE,
              ),
              ResponsiveBreakpoint.resize(
                Constant.tabletBreakpoint,
                name: TABLET,
              ),
              ResponsiveBreakpoint.resize(
                Constant.desktopBreakpoint,
                name: DESKTOP,
              ),
            ],
          ),
          title: Constant.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          scrollBehavior: ScrollBehaviorConfig(),
        ),
      ),
    );
  }
}
