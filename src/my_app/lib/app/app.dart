import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/app/config/scroll_behavior.dart';
import 'package:my_app/app/constants/constant.dart';
import 'package:my_app/app/generated/l10n.dart';
import 'package:my_app/app/routes/app_router.dart';
import 'package:my_app/app/themes/app_theme.dart';
import 'package:my_app/app/utils/injection.dart';
import 'package:my_app/core/domain/bloc/my_app/my_app_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  App({super.key});

  final GoRouter routerConfig =
      getIt<AppRouter>(param1: getIt<MyAppBloc>()).router;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<MyAppBloc>(
            create: (BuildContext context) => getIt<MyAppBloc>(),
          ),
        ],
        child: BlocBuilder<MyAppBloc, MyAppState>(
          builder: (BuildContext context, MyAppState state) =>
              MaterialApp.router(
            title: Constant.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            scrollBehavior: ScrollBehaviorConfig(),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.delegate.supportedLocales,
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
            routerConfig: routerConfig,
          ),
        ),
      );
}
