import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) => {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
        text: Constant.appName,
        textAlign: TextAlign.center,
        style: context.textTheme.displayLarge
            ?.copyWith(color: context.colorScheme.primary),
      );
}
