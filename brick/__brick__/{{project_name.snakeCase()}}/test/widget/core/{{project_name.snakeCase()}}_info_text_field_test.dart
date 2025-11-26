// prefer_const_constructors is ignored to ensure the constructor is hit by code coverage.
// ignore_for_file: discarded_futures, prefer_const_constructors

import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_info_text_field.dart';

import '../../utils/test_utils.dart';

void main() {
  group({{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField, () {
    goldenTest(
      'renders correctly',
      fileName: '{{project_name.snakeCase()}}_info_text_field'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default(expanded)',
            constraints: const BoxConstraints(minWidth: 200),
            child: {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(title: 'Title', description: 'Description'),
          ),
          GoldenTestScenario(
            name: 'shrink',
            child: {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(title: 'Title', description: 'Description', isExpanded: false),
          ),
        ],
      ),
    );
  });
}
