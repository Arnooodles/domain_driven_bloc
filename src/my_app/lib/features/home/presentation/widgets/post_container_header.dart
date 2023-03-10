import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/app/themes/text_styles.dart';
import 'package:very_good_core/app/utils/extensions.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';

class PostContainerHeader extends StatelessWidget {
  const PostContainerHeader({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(Insets.xs),
            child: Text(
              context.l10n.post__post_details__author_and_created_date(
                post.author.getOrCrash(),
                post.createdUtc.ago,
              ),
              style: AppTextStyle.bodySmall.copyWith(
                color: context.colorScheme.secondary,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              if (post.linkFlairText.getOrCrash().isNotNullOrBlank)
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Insets.xxs,
                    horizontal: Insets.xs,
                  ),
                  decoration: BoxDecoration(
                    color: post.linkFlairBackgroundColor,
                    borderRadius: AppTheme.defaultBoardRadius,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: Insets.xs),
                  child: Text(
                    post.linkFlairText.getOrCrash(),
                    style: AppTextStyle.bodySmall
                        .copyWith(color: context.colorScheme.onSecondary),
                  ),
                ),
              Expanded(
                child: Text(
                  post.title.getOrCrash(),
                  style: AppTextStyle.titleMedium.copyWith(
                    color: context.colorScheme.onSecondaryContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      );
}
