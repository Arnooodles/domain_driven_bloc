import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/route.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_nav_bar.dart';

import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/mock_localization.dart';
import '../../../utils/test_utils.dart';
import 'very_good_core_nav_bar_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<GoRouter>()])
void main() {
  late MockGoRouter routerHome;
  late MockGoRouter routerProfile;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    routerHome = MockGoRouter();
    routerProfile = MockGoRouter();
    when(routerHome.location).thenAnswer((_) => RouteName.home.path);
    when(routerProfile.location).thenAnswer((_) => RouteName.profile.path);
    scrollControllers = <AppScrollController, ScrollController>{
      AppScrollController.home: ScrollController(),
      AppScrollController.profile: ScrollController(),
    };
  });
  group('VeryGoodCoreNavBar Widget Tests', () {
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
            child: MockLocalization(
              child: MockGoRouterProvider(
                router: routerHome,
                child: PreferredSize(
                  preferredSize:
                      const Size.fromHeight(AppTheme.defaultNavBarHeight),
                  child:
                      VeryGoodCoreNavBar(scrollControllers: scrollControllers),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'profile tab is selected',
            constraints: const BoxConstraints(minWidth: 400),
            child: MockLocalization(
              child: MockGoRouterProvider(
                router: routerProfile,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                  child:
                      VeryGoodCoreNavBar(scrollControllers: scrollControllers),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
