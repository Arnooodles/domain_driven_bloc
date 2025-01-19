import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/entity/enum/text_field_type.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text_field.dart';

import '../../utils/test_utils.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });

  tearDown(() {
    controller.dispose();
    focusNode.dispose();
  });

  group(VeryGoodCoreTextField, () {
    GoldenTestGroup buildTextFieldTestGroup({
      TextFieldType textFieldType = TextFieldType.normal,
    }) =>
        GoldenTestGroup(
          children: <Widget>[
            GoldenTestScenario(
              name: 'default',
              constraints: const BoxConstraints(minWidth: 200),
              child: VeryGoodCoreTextField(
                controller: controller,
                labelText: 'Label',
                textFieldType: textFieldType,
              ),
            ),
            GoldenTestScenario(
              name: 'disabled',
              constraints: const BoxConstraints(minWidth: 200),
              child: VeryGoodCoreTextField(
                controller: controller,
                labelText: 'Label',
                textFieldType: textFieldType,
                disabled: true,
              ),
            ),
            GoldenTestScenario(
              name: 'is focused w/ hint',
              constraints: const BoxConstraints(minWidth: 200),
              child: Builder(
                builder: (BuildContext context) {
                  focusNode.requestFocus();

                  return VeryGoodCoreTextField(
                    controller: controller,
                    labelText: 'Label',
                    hintText: 'hint',
                    textFieldType: textFieldType,
                    autofocus: true,
                    focusNode: focusNode,
                  );
                },
              ),
            ),
            GoldenTestScenario(
              name: 'is focused w/o hint',
              constraints: const BoxConstraints(minWidth: 200),
              child: Builder(
                builder: (BuildContext context) {
                  focusNode.requestFocus();

                  return VeryGoodCoreTextField(
                    controller: controller,
                    labelText: 'Label',
                    textFieldType: textFieldType,
                    autofocus: true,
                    focusNode: focusNode,
                  );
                },
              ),
            ),
            GoldenTestScenario(
              name: 'with value',
              constraints: const BoxConstraints(minWidth: 200),
              child: VeryGoodCoreTextField(
                controller: TextEditingController(text: 'Value'),
                labelText: 'Label',
                textFieldType: textFieldType,
                autofocus: true,
              ),
            ),
            GoldenTestScenario(
              name: 'is focused w/ value',
              constraints: const BoxConstraints(minWidth: 200),
              child: Builder(
                builder: (BuildContext context) {
                  focusNode.requestFocus();

                  return VeryGoodCoreTextField(
                    controller: TextEditingController(text: 'Value'),
                    labelText: 'Label',
                    textFieldType: textFieldType,
                    autofocus: true,
                    focusNode: focusNode,
                  );
                },
              ),
            ),
          ],
        );

    goldenTest(
      'renders correctly the default text field',
      fileName: 'very_good_core_text_field'.goldensVersion,
      builder: buildTextFieldTestGroup,
    );

    goldenTest(
      'renders correctly the default text field form',
      fileName: 'very_good_core_text_field_form'.goldensVersion,
      builder: () => buildTextFieldTestGroup(textFieldType: TextFieldType.form),
    );

    goldenTest(
      'renders correctly when isPassword is true',
      fileName: 'very_good_core_text_field_password'.goldensVersion,
      builder: () =>
          buildTextFieldTestGroup(textFieldType: TextFieldType.password),
    );

    goldenTest(
      'renders correctly when is true and password is visible',
      fileName: 'very_good_core_text_field_password_visible'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        for (final Element element in find.byType(GestureDetector).evaluate()) {
          await tester.tapAt(tester.getCenter(find.byWidget(element.widget)));
        }
        await tester.pumpAndSettle();
      },
      builder: () =>
          buildTextFieldTestGroup(textFieldType: TextFieldType.password),
    );
  });
}
