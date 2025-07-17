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
    Widget buildIcon(Either<String, IconData> icon, {Color? color, Widget? child}) => DefaultAssetBundle(
      bundle: MockAssetBundle(),
      child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: icon, color: color, child: child),
    );
    goldenTest(
      'renders correctly',
      fileName: '{{project_name.snakeCase()}}_icon'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(name: 'svg icon', child: buildIcon(left(Assets.icons.launcherIcon.path))),

          GoldenTestScenario(
            name: 'svg icon with custom color',
            child: buildIcon(left(Assets.icons.launcherIcon.path), color: Colors.red),
          ),
          GoldenTestScenario(
            name: 'svg icon with custom color and child',
            child: buildIcon(left(Assets.icons.launcherIcon.path), color: Colors.red, child: const Text('Child')),
          ),
          GoldenTestScenario(name: 'material icon', child: buildIcon(right(Icons.abc))),
          GoldenTestScenario(
            name: 'material icon with custom color',
            child: buildIcon(right(Icons.abc), color: Colors.red),
          ),
          GoldenTestScenario(
            name: 'material icon with child',
            child: buildIcon(right(Icons.abc), child: const Text('Child')),
          ),
          GoldenTestScenario(
            name: 'material icon with override color',
            child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.abc), color: Colors.red).copyWith(copyColor: Colors.blue),
          ),
        ],
      ),
    );
  });
}
