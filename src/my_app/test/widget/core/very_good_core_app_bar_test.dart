import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';

import '../../utils/generated_mocks.mocks.dart';
import '../../utils/mock_go_router_provider.dart';
import '../../utils/test_utils.dart';

void main() {
  late MockGoRouter router;
  int counter = 0;

  MockGoRouter setUpRouter({required bool canPop}) {
    router = MockGoRouter();
    when(router.canPop()).thenAnswer((_) => canPop);
    return router;
  }

  tearDown(() {
    router.dispose();
  });

  group(VeryGoodCoreAppBar, () {
    goldenTest(
      'renders correctly',
      fileName: 'very_good_core_app_bar'.goldensVersion,
      pumpWidget: (WidgetTester tester, Widget widget) async {
        await mockNetworkImages(() => tester.pumpWidget(widget));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'without action and back button',
            child: MockGoRouterProvider(
              router: setUpRouter(canPop: false),
              child: const VeryGoodCoreAppBar(),
            ),
          ),
          GoldenTestScenario(
            name: 'with action but no back button',
            child: MockGoRouterProvider(
              router: setUpRouter(canPop: false),
              child: VeryGoodCoreAppBar(
                actions: <Widget>[
                  IconButton(
                    onPressed: () => counter++,
                    icon: VeryGoodCoreIcon(icon: right(Icons.light_mode)),
                  ),
                ],
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'without action but have a back button',
            child: MockGoRouterProvider(
              router: setUpRouter(canPop: true),
              child: const VeryGoodCoreAppBar(
                leading: BackButton(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with action and back button',
            child: MockGoRouterProvider(
              router: setUpRouter(canPop: true),
              child: VeryGoodCoreAppBar(
                actions: <Widget>[
                  IconButton(
                    onPressed: () => counter++,
                    icon: VeryGoodCoreIcon(icon: right(Icons.light_mode)),
                  ),
                ],
                leading: const BackButton(),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
