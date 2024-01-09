import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';

import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/test_utils.dart';
import 'very_good_core_app_bar_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<GoRouter>()])
void main() {
  late MockGoRouter routerWithBack;
  late MockGoRouter routerWithOutBack;
  int counter = 0;

  setUp(() {
    routerWithBack = MockGoRouter();
    routerWithOutBack = MockGoRouter();
    when(routerWithBack.canPop()).thenAnswer((_) => true);
    when(routerWithOutBack.canPop()).thenAnswer((_) => false);
  });

  group('VeryGoodCoreAppBar Widget Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'very_good_core_app_bar'.goldensVersion,
      pumpWidget: (WidgetTester tester, Widget widget) async {
        await mockNetworkImages(() => tester.pumpWidget(widget));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'without avatar and back button',
            child: MockGoRouterProvider(
              router: routerWithOutBack,
              child: const VeryGoodCoreAppBar(),
            ),
          ),
          GoldenTestScenario(
            name: 'with action but no leading button',
            child: MockGoRouterProvider(
              router: routerWithOutBack,
              child: VeryGoodCoreAppBar(
                actions: <Widget>[
                  IconButton(
                    onPressed: () => counter++,
                    icon: const Icon(Icons.light_mode),
                  ),
                ],
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'without action but have a leading button',
            child: MockGoRouterProvider(
              router: routerWithBack,
              child: const VeryGoodCoreAppBar(
                leading: BackButton(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with avatar and back button',
            child: MockGoRouterProvider(
              router: routerWithBack,
              child: VeryGoodCoreAppBar(
                actions: <Widget>[
                  IconButton(
                    onPressed: () => counter++,
                    icon: const Icon(Icons.light_mode),
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
