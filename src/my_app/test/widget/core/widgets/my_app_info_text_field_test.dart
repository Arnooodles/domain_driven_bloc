import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/core/presentation/widgets/my_app_info_text_field.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('MyAppInfoTextField Widget Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'my_app_info_text_field'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default(expanded)',
            constraints: const BoxConstraints(minWidth: 200),
            child: const MyAppInfoTextField(
              title: 'Title',
              description: 'Description',
            ),
          ),
          GoldenTestScenario(
            name: 'shrink',
            child: const MyAppInfoTextField(
              title: 'Title',
              description: 'Description',
              isExpanded: false,
            ),
          ),
        ],
      ),
    );
  });
}
