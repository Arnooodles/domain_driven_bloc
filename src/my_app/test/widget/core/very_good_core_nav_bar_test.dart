// ignore_for_file: discarded_futures

import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/app/routes/app_routes.dart';
import 'package:very_good_core/core/domain/cubit/app_core/app_core_cubit.dart';
import 'package:very_good_core/core/domain/cubit/hidable/hidable_cubit.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_nav_bar.dart';

import '../../utils/generated_mocks.mocks.dart';
import '../../utils/mock_go_router_provider.dart';
import '../../utils/mock_localization.dart';
import '../../utils/test_utils.dart';

void main() {
  late MockGoRouter router;
  late MockGoRouterDelegate routerDelegate;
  late MockRouteMatchList currentConfiguration;
  late MockAppCoreCubit appCoreCubit;
  late MockHidableCubit hidableCubit;
  late MockStatefulNavigationShell navigationShell;
  late MockAppLocalizationCubit appLocalizationCubit;

  setUp(() {
    appCoreCubit = MockAppCoreCubit();
    hidableCubit = MockHidableCubit();
    appLocalizationCubit = MockAppLocalizationCubit();
    provideDummy(AppCoreState.initial());
    when(
      appCoreCubit.stream,
    ).thenAnswer((_) => Stream<AppCoreState>.fromIterable(<AppCoreState>[AppCoreState.initial()]));
    when(appCoreCubit.state).thenAnswer((_) => AppCoreState.initial());
    when(hidableCubit.stream).thenAnswer((_) => Stream<bool>.fromIterable(<bool>[true]));
    when(hidableCubit.state).thenAnswer((_) => true);
    when(appLocalizationCubit.state).thenAnswer((_) => AppLocale.values.first.buildSync());
  });

  tearDown(() async {
    await appCoreCubit.close();
    await hidableCubit.close();
    await appLocalizationCubit.close();
  });

  MockGoRouter setUpRouter(String path, int index) {
    router = MockGoRouter();
    routerDelegate = MockGoRouterDelegate();
    navigationShell = MockStatefulNavigationShell();
    currentConfiguration = MockRouteMatchList();
    when(currentConfiguration.uri).thenAnswer((_) => Uri(path: path));
    when(routerDelegate.currentConfiguration).thenAnswer((_) => currentConfiguration);
    when(router.routerDelegate).thenAnswer((_) => routerDelegate);
    when(navigationShell.currentIndex).thenAnswer((_) => index);
    return router;
  }

  Widget buildNavBar(MockGoRouter router) => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<AppCoreCubit>(create: (BuildContext context) => appCoreCubit),
      BlocProvider<HidableCubit>(create: (BuildContext context) => hidableCubit),
    ],
    child: MockLocalization(
      appLocalizationCubit: appLocalizationCubit,
      child: MockGoRouterProvider(
        router: router,
        child: VeryGoodCoreNavBar(navigationShell: navigationShell),
      ),
    ),
  );

  group(VeryGoodCoreNavBar, () {
    goldenTest(
      'renders correctly',
      fileName: 'very_good_core_nav_bar'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pumpAndSettle();
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'home tab is selected',
            constraints: const BoxConstraints(minWidth: 400),
            child: buildNavBar(setUpRouter(const HomeRoute().location, 0)),
          ),
          GoldenTestScenario(
            name: 'profile tab is selected',
            constraints: const BoxConstraints(minWidth: 400),
            child: buildNavBar(setUpRouter(const ProfileRoute().location, 1)),
          ),
        ],
      ),
    );
  });
}
