import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/routes/route_name.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/bloc/hidable/hidable_bloc.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_nav_bar.dart';

import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/mock_localization.dart';
import '../../../utils/test_utils.dart';
import 'very_good_core_nav_bar_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<GoRouterDelegate>(),
  MockSpec<GoRouter>(),
  MockSpec<StatefulNavigationShell>(),
  MockSpec<RouteMatchList>(),
  MockSpec<AppCoreBloc>(),
  MockSpec<HidableBloc>(),
])
void main() {
  late MockGoRouter router;
  late MockGoRouterDelegate routerDelegate;
  late MockRouteMatchList currentConfiguration;
  late MockAppCoreBloc appCoreBloc;
  late MockHidableBloc hidableBloc;
  late MockStatefulNavigationShell navigationShell;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    appCoreBloc = MockAppCoreBloc();
    hidableBloc = MockHidableBloc();
    scrollControllers = mockScrollControllers;
    when(appCoreBloc.stream).thenAnswer(
      (_) => Stream<AppCoreState>.fromIterable(
        <AppCoreState>[
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
        ],
      ),
    );
    when(appCoreBloc.state).thenAnswer(
      (_) =>
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
    );
    when(hidableBloc.stream).thenAnswer(
      (_) => Stream<bool>.fromIterable(
        <bool>[
          true,
        ],
      ),
    );
    when(hidableBloc.state).thenAnswer(
      (_) => true,
    );
  });

  tearDown(() {
    appCoreBloc.close();
    hidableBloc.close();
  });

  MockGoRouter setUpRouter(String path, int index) {
    router = MockGoRouter();
    routerDelegate = MockGoRouterDelegate();
    navigationShell = MockStatefulNavigationShell();
    currentConfiguration = MockRouteMatchList();
    when(currentConfiguration.uri).thenAnswer((_) => Uri(path: path));
    when(routerDelegate.currentConfiguration)
        .thenAnswer((_) => currentConfiguration);
    when(router.routerDelegate).thenAnswer((_) => routerDelegate);
    when(navigationShell.currentIndex).thenAnswer((_) => index);
    return router;
  }

  Widget buildNavBar(MockGoRouter router) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<AppCoreBloc>(
            create: (BuildContext context) => appCoreBloc,
          ),
          BlocProvider<HidableBloc>(
            create: (BuildContext context) => hidableBloc,
          ),
        ],
        child: MockLocalization(
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
            child: buildNavBar(setUpRouter(RouteName.home.path, 0)),
          ),
          GoldenTestScenario(
            name: 'profile tab is selected',
            constraints: const BoxConstraints(minWidth: 400),
            child: buildNavBar(setUpRouter(RouteName.profile.path, 1)),
          ),
        ],
      ),
    );
  });
}
