import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(leading: BackButton()),
    body: SingleChildScrollView(
      padding: Paddings.allLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(post.title.getValue(), style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          Gap.medium(),
          if (post.tags.isNotEmpty) ...<Widget>[
            Wrap(
              spacing: AppSizes.xSmall,
              runSpacing: AppSizes.xxSmall,
              children: post.tags
                  .map(
                    (String tag) => Chip(
                      label: Text('#$tag', style: context.textTheme.bodySmall),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      shape: const RoundedRectangleBorder(borderRadius: AppTheme.defaultBorderRadius),
                    ),
                  )
                  .toList(),
            ),
            Gap.medium(),
          ],
          Text(post.body.getValue(), style: context.textTheme.bodyLarge),
          Gap.large(),
          const Divider(),
          Gap.small(),
          _ReactionsRow(post: post),
        ],
      ),
    ),
  );
}

class _ReactionsRow extends StatelessWidget {
  const _ReactionsRow({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _ReactionItem(
        icon: Icons.thumb_up_outlined,
        color: context.colorScheme.primary,
        label: post.likes.getValue().toString(),
      ),
      _ReactionItem(
        icon: Icons.thumb_down_outlined,
        color: context.colorScheme.error,
        label: post.dislikes.getValue().toString(),
      ),
      _ReactionItem(
        icon: Icons.remove_red_eye_outlined,
        color: context.colorScheme.primary,
        label: post.views.getValue().toString(),
      ),
    ],
  );
}

class _ReactionItem extends StatelessWidget {
  const _ReactionItem({required this.icon, required this.color, required this.label});

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Icon(icon, color: color, size: AppSizes.large),
      Gap.xSmall(),
      Text(label, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ],
  );
}
