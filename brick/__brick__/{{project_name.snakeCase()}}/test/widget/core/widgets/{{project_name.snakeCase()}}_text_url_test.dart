import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/value_object.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text_url.dart';

import '../../../utils/test_utils.dart';

void main() {
  group({{#pascalCase}}{{project_name}}{{/pascalCase}}TextUrl, () {
    int count = 0;
    const String url = 'https://www.example.com';
    goldenTest(
      'renders correctly',
      fileName: '{{project_name.snakeCase()}}_text_url'.goldensVersion,
      constraints: const BoxConstraints(minWidth: 200),
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: SizedBox(
              height: 20,
              child: {{#pascalCase}}{{project_name}}{{/pascalCase}}TextUrl(
                url: Url(url),
                onTap: () => count++,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'no icon',
            child: SizedBox(
              height: 20,
              child: {{#pascalCase}}{{project_name}}{{/pascalCase}}TextUrl(
                url: Url(url),
                onTap: () => count++,
                isShowIcon: false,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
