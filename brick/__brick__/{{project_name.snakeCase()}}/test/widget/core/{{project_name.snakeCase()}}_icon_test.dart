import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/assets.gen.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';

import '../../utils/mock_asset_bundle.dart';
import '../../utils/test_utils.dart';

void main() {
  group({{#pascalCase}}{{project_name}}{{/pascalCase}}Icon, () {
    Widget buildIcon(Either<String, IconData> icon, {Color? color}) =>
        DefaultAssetBundle(
          bundle: MockAssetBundle(),
          child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(
            icon: icon,
            color: color,
          ),
        );
    goldenTest(
      'renders correctly',
      fileName: '{{project_name.snakeCase()}}_icon'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'svg icon',
            child: buildIcon(
              left(Assets.icons.launcherIcon.path),
            ),
          ),
          GoldenTestScenario(
            name: 'svg icon with custom color',
            child: buildIcon(
              left(Assets.icons.launcherIcon.path),
              color: Colors.red,
            ),
          ),
          GoldenTestScenario(
            name: 'material icon',
            child: buildIcon(
              right(Icons.abc),
            ),
          ),
        ],
      ),
    );
  });
}
