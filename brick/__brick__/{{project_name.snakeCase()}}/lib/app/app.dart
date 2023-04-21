import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:{{project_name.snakeCase()}}/app/config/scroll_behavior_config.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/l10n.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/app_router.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/theme/theme_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';

// ignore_for_file: avoid-returning-widgets
class App extends StatelessWidget {
  App({super.key});

  final AppRouter appRouter = getIt<AppRouter>(param1: getIt<AuthBloc>());

  List<BlocProvider<dynamic>> get providers => <BlocProvider<dynamic>>[
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

  List<ResponsiveBreakpoint> get breakpoints => <ResponsiveBreakpoint>[
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

  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: providers,
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (BuildContext context, ThemeMode themeMode) =>
              MaterialApp.router(
            routerConfig: appRouter.router,
            builder: (BuildContext context, Widget? child) =>
                ResponsiveWrapper.builder(
              child,
              minWidth: Constant.mobileBreakpoint,
              breakpoints: breakpoints,
            ),
            title: Constant.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            localizationsDelegates: localizationsDelegates,
            supportedLocales: AppLocalizations.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            scrollBehavior: ScrollBehaviorConfig(),
          ),
        ),
      );
}
