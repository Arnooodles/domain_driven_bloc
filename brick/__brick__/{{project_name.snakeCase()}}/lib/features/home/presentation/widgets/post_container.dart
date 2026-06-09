import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/app_routes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_footer.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_header.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({required this.post, super.key});

  static const int _maxBodyLines = 5;

  final Post post;

  @override
  Widget build(BuildContext context) => Padding(
    padding: Paddings.horizontalSmall,
    child: GestureDetector(
      onTap: () => _launchPostDetails(context),
      child: Card(
        child: Padding(
          padding: Paddings.allXSmall,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PostContainerHeader(title: post.title.getValue()),
              Padding(
                padding: Paddings.horizontalSmall,
                child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
                  text: post.body.getValue(),
                  style: context.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: _maxBodyLines,
                ),
              ),
              Gap.small(),
              if (post.tags.isNotEmpty)
                Padding(
                  padding: Paddings.horizontalSmall,
                  child: Wrap(
                    spacing: AppSizes.xxSmall,
                    children: post.tags
                        .take(3)
                        .map(
                          (String tag) => Skeleton.leaf(
                            child: Chip(
                              label: Text('#$tag', style: context.textTheme.bodySmall),
                              padding: Paddings.allXxSmall,
                              visualDensity: VisualDensity.compact,
                              backgroundColor: context.colorScheme.surfaceContainerLow,
                              shape: const RoundedRectangleBorder(borderRadius: AppTheme.defaultBorderRadius),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              Gap.xSmall(),
              PostContainerFooter(post: post),
            ],
          ),
        ),
      ),
    ),
  );

  void _launchPostDetails(BuildContext context) {
    PostDetailsRoute(postId: post.uid.getValue(), $extra: post).go(context);
  }
}
