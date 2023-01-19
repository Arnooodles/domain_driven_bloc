import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/core/presentation/widgets/my_app_button.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('MyAppButton Widget Tests', () {
    int counter = 0;

    GoldenTestGroup buildButtonTestGroup() => GoldenTestGroup(
          children: <Widget>[
            GoldenTestScenario(
              name: 'default',
              child: MyAppButton(
                text: 'Button',
                onPressed: () => counter++,
              ),
            ),
            GoldenTestScenario(
              name: 'isExpanded',
              constraints: const BoxConstraints(minWidth: 200),
              child: MyAppButton(
                text: 'Button',
                isExpanded: true,
                onPressed: () => counter++,
              ),
            ),
            GoldenTestScenario(
              name: 'isDisabled',
              child: MyAppButton(
                text: 'Button',
                isEnabled: false,
                onPressed: () => counter++,
              ),
            ),
            GoldenTestScenario(
              name: 'isDisabled & isExpanded',
              constraints: const BoxConstraints(minWidth: 200),
              child: MyAppButton(
                text: 'Button',
                isExpanded: true,
                isEnabled: false,
                onPressed: () => counter++,
              ),
            ),
          ],
        );

    goldenTest(
      'renders correctly in initial state',
      fileName: 'my_app_button'.goldensVersion,
      builder: buildButtonTestGroup,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
    );
  });
}
