import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_text_style.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';

class PostContainerHeader extends StatelessWidget {
  const PostContainerHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: Paddings.allSmall,
    child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
      text: title,
      style: context.textTheme.titleMedium?.copyWith(fontWeight: AppFontWeight.semiBold),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    ),
  );
}
