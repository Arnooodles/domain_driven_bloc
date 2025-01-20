import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/datetime_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

class PostContainerHeader extends StatelessWidget {
  const PostContainerHeader({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: Paddings.allXSmall,
            child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
              text: context.i18n.post.label.author_and_created_date(
                author: post.author.getOrCrash(),
                date: post.createdUtc.ago,
              ),
              style: context.textTheme.bodySmall,
            ),
          ),
          Row(
            children: <Widget>[
              if (post.linkFlairText.getOrCrash().isNotNullOrBlank)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Insets.xxSmall,
                    horizontal: Insets.xSmall,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(
                      context,
                      post.linkFlairBackgroundColor,
                    ),
                    borderRadius: AppTheme.defaultBoardRadius,
                  ),
                  margin: Paddings.horizontalXSmall,
                  child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
                    text: post.linkFlairText.getOrCrash(),
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: context.colorScheme.onSecondary),
                  ),
                ),
              if (!post.linkFlairText.getOrCrash().isNotNullOrBlank)
                Gap.xSmall(),
              Expanded(
                child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
                  text: post.title.getOrCrash(),
                  style: context.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      );

  Color _getBackgroundColor(
    BuildContext context,
    Color linkFlairBackgroundColor,
  ) =>
      linkFlairBackgroundColor == AppColors.transparent
          ? context.colorScheme.secondary.withValues(alpha: 0.5)
          : linkFlairBackgroundColor;
}
