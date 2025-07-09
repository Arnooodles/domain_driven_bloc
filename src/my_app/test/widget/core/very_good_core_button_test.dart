import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/enum/button_type.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_button.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';

import '../../utils/test_utils.dart';

void main() {
  group(VeryGoodCoreButton, () {
    int counter = 0;

    List<Widget> buildButtons(Widget? icon, ButtonType buttonType) => <Widget>[
      GoldenTestScenario(
        name: 'default ${buttonType.name} button',
        child: VeryGoodCoreButton(text: 'Button', buttonType: buttonType, onPressed: () => counter++, icon: icon),
      ),
      GoldenTestScenario(
        name: 'isExpanded ${buttonType.name} button',
        constraints: const BoxConstraints(minWidth: 200),
        child: VeryGoodCoreButton(
          text: 'Button',
          isExpanded: true,
          buttonType: buttonType,
          onPressed: () => counter++,
          icon: icon,
        ),
      ),
      GoldenTestScenario(
        name: 'isDisabled ${buttonType.name} button',
        child: VeryGoodCoreButton(
          text: 'Button',
          isEnabled: false,
          buttonType: buttonType,
          onPressed: () => counter++,
          icon: icon,
        ),
      ),
      GoldenTestScenario(
        name: 'isDisabled & isExpanded ${buttonType.name} button',
        constraints: const BoxConstraints(minWidth: 200),
        child: VeryGoodCoreButton(
          text: 'Button',
          isEnabled: false,
          isExpanded: true,
          buttonType: buttonType,
          onPressed: () => counter++,
          icon: icon,
        ),
      ),
      // isLoading Buttons
      GoldenTestScenario(
        name: 'default loading ${buttonType.name} button',
        child: VeryGoodCoreButton(
          text: 'Button',
          isLoading: true,
          buttonType: buttonType,
          onPressed: () => counter++,
          icon: icon,
        ),
      ),
      GoldenTestScenario(
        name: 'isExpanded loading ${buttonType.name} button',
        constraints: const BoxConstraints(minWidth: 200),
        child: VeryGoodCoreButton(
          text: 'Button',
          isExpanded: true,
          isLoading: true,
          buttonType: buttonType,
          onPressed: () => counter++,
          icon: icon,
        ),
      ),
      GoldenTestScenario(
        name: 'isDisabled loading ${buttonType.name} button',
        child: VeryGoodCoreButton(
          text: 'Button',
          isEnabled: false,
          isLoading: true,
          buttonType: buttonType,
          onPressed: () => counter++,
          icon: icon,
        ),
      ),
      GoldenTestScenario(
        name: 'isDisabled & isExpanded loading ${buttonType.name} button',
        constraints: const BoxConstraints(minWidth: 200),
        child: VeryGoodCoreButton(
          text: 'Button',
          isEnabled: false,
          isExpanded: true,
          buttonType: buttonType,
          isLoading: true,
          onPressed: () => counter++,
          icon: icon,
        ),
      ),
    ];

    GoldenTestGroup buildButtonTestGroup({Widget? icon}) => GoldenTestGroup(
      children: <Widget>[
        ...buildButtons(icon, ButtonType.elevated),
        ...buildButtons(icon, ButtonType.filled),
        ...buildButtons(icon, ButtonType.tonal),
        ...buildButtons(icon, ButtonType.outlined),
        ...buildButtons(icon, ButtonType.text),
      ],
    );

    goldenTest(
      'renders correctly ',
      fileName: 'very_good_core_button'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      pumpWidget: (WidgetTester tester, Widget widget) async {
        await tester.pumpWidget(widget);
      },
      builder: buildButtonTestGroup,
    );
    goldenTest(
      'renders correctly and with icon',
      fileName: 'very_good_core_button_icon'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      pumpWidget: (WidgetTester tester, Widget widget) async {
        await tester.pumpWidget(widget);
      },
      builder: () => buildButtonTestGroup(icon: VeryGoodCoreIcon(icon: right(Icons.add))),
    );
  });
}
