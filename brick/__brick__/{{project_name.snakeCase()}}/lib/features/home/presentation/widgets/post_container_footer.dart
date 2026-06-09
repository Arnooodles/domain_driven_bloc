import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

class PostContainerFooter extends StatelessWidget {
  const PostContainerFooter({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      _FooterItems(leftIcon: Icons.thumb_up_outlined, value: post.likes.getValue().toString()),
      _FooterItems(leftIcon: Icons.thumb_down_outlined, value: post.dislikes.getValue().toString()),
      _FooterItems(leftIcon: Icons.remove_red_eye_outlined, value: post.views.getValue().toString()),
    ],
  );
}

class _FooterItems extends StatelessWidget {
  const _FooterItems({required this.leftIcon, required this.value});

  final IconData leftIcon;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: Paddings.horizontalSmall,
    decoration: const BoxDecoration(borderRadius: AppTheme.defaultBorderRadius),
    margin: Paddings.horizontalSmall,
    child: Row(
      children: <Widget>[
        {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(leftIcon), size: context.textTheme.bodyLarge?.fontSize ?? 14),
        Padding(
          padding: Paddings.allXSmall,
          child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(text: value, style: context.textTheme.bodyMedium),
        ),
      ],
    ),
  );
}
