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
      _FooterItems(
        leftIcon: Icons.arrow_upward_rounded,
        value: post.upvotes.getValue() == 0 ? context.i18n.post.label.vote : post.upvotes.getValue().toString(),
        rightIcon: Icons.arrow_downward_rounded,
      ),
      _FooterItems(leftIcon: Icons.chat_bubble_outline, value: post.comments.getValue().toString()),
    ],
  );
}

class _FooterItems extends StatelessWidget {
  const _FooterItems({required this.leftIcon, required this.value, this.rightIcon});

  final IconData leftIcon;
  final IconData? rightIcon;

  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: Paddings.horizontalXSmall,
    decoration: const BoxDecoration(borderRadius: AppTheme.defaultBorderRadius),
    margin: Paddings.horizontalXxSmall,
    child: Row(
      children: <Widget>[
        {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(leftIcon), size: (context.textTheme.bodySmall?.fontSize ?? 14) * 1.5),
        Padding(
          padding: Paddings.allXSmall,
          child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(text: value, style: context.textTheme.bodySmall),
        ),
        if (rightIcon != null)
          {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(rightIcon!), size: (context.textTheme.bodySmall?.fontSize ?? 14) * 1.5),
      ],
    ),
  );
}
