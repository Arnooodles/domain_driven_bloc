import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/routes/app_router.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';
import 'package:very_good_core/core/domain/bloc/app_localization/app_localization_bloc.dart';
import 'package:very_good_core/core/domain/bloc/hidable/hidable_bloc.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  final List<BlocProvider<dynamic>> _globalProviders = <BlocProvider<dynamic>>[
    BlocProvider<AppLifeCycleBloc>(create: (BuildContext context) => getIt<AppLifeCycleBloc>()),
    BlocProvider<AppLocalizationBloc>(create: (BuildContext context) => getIt<AppLocalizationBloc>()),
    BlocProvider<AppCoreBloc>(create: (BuildContext context) => getIt<AppCoreBloc>()),
    BlocProvider<ThemeBloc>(create: (BuildContext context) => getIt<ThemeBloc>()),
    BlocProvider<AuthBloc>(create: (BuildContext context) => getIt<AuthBloc>()),
    BlocProvider<HidableBloc>(create: (BuildContext context) => getIt<HidableBloc>()),
  ];

  final List<Breakpoint> _breakpoints = <Breakpoint>[
    const Breakpoint(start: 0, end: Constant.mobileBreakpoint, name: MOBILE),
    const Breakpoint(start: Constant.mobileBreakpoint + 1, end: Constant.tabletBreakpoint, name: TABLET),
    const Breakpoint(start: Constant.tabletBreakpoint + 1, end: double.infinity, name: DESKTOP),
  ];

  List<Condition<double>> _getResponsiveWidth(BuildContext context) => <Condition<double>>[
    const Condition<double>.equals(name: MOBILE, value: Constant.mobileBreakpoint),
    const Condition<double>.equals(name: TABLET, value: Constant.tabletBreakpoint),
    Condition<double>.equals(name: DESKTOP, value: context.screenWidth),
  ];

  @override
  Widget build(BuildContext context) {
    /// This will tell you which image is oversized by throwing an exception.
    debugInvertOversizedImages = true;
    return MultiBlocProvider(
      providers: _globalProviders,
      child: Builder(
        builder: (BuildContext context) => MaterialApp.router(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
            },
          ),
          routerConfig: AppRouter.router,
          builder: (BuildContext context, Widget? child) => ResponsiveBreakpoints.builder(
            child: Builder(
              builder: (BuildContext context) => ResponsiveScaledBox(
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: Constant.mobileBreakpoint,
                  conditionalValues: _getResponsiveWidth(context),
                ).value,
                child: child!,
              ),
            ),
            breakpoints: _breakpoints,
          ),
          title: Constant.appName,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: context.watch<ThemeBloc>().state,
          themeAnimationCurve: Curves.fastOutSlowIn,
          themeAnimationDuration: const Duration(milliseconds: 500),
          locale: context.watch<AppLocalizationBloc>().state.$meta.locale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: Constant.localizationDelegates,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
