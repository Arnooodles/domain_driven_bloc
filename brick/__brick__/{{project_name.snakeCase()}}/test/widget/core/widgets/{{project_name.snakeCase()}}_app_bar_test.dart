import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';

import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/test_utils.dart';
import '{{project_name.snakeCase()}}_app_bar_test.mocks.dart';

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

  group('{{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar Widget Tests', () {
    goldenTest(
      'renders correctly',
      fileName: '{{project_name.snakeCase()}}_app_bar'.goldensVersion,
      pumpWidget: (WidgetTester tester, Widget widget) async {
        await mockNetworkImages(() => tester.pumpWidget(widget));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'without avatar and back button',
            child: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: MockGoRouterProvider(
                router: routerWithOutBack,
                child: const {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with action but no leading button',
            child: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: MockGoRouterProvider(
                router: routerWithOutBack,
                child: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => counter++,
                      icon: const Icon(Icons.light_mode),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'without action but have a leading button',
            child: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: MockGoRouterProvider(
                router: routerWithBack,
                child: const {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(
                  leading: BackButton(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with avatar and back button',
            child: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: MockGoRouterProvider(
                router: routerWithBack,
                child: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(
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
          ),
        ],
      ),
    );
  });
}
