import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/extensions/datetime_ext.dart';
import 'package:very_good_core/app/themes/app_colors.dart';
import 'package:very_good_core/app/themes/app_sizes.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

class PostContainerHeader extends StatelessWidget {
  const PostContainerHeader({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: Paddings.allXSmall,
        child: VeryGoodCoreText(
          text: context.i18n.post.label.author_and_created_date(
            author: post.author.getValue(),
            date: post.createdUtc.ago,
          ),
          style: context.textTheme.bodySmall,
        ),
      ),
      Row(
        children: <Widget>[
          if (post.linkFlairText?.getValue().isNotNullOrBlank ?? false) ...<Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xxSmall, horizontal: AppSizes.xSmall),
              decoration: BoxDecoration(
                color: _getBackgroundColor(context, post.linkFlairBackgroundColor),
                borderRadius: AppTheme.defaultBorderRadius,
              ),
              margin: Paddings.horizontalXSmall,
              child: VeryGoodCoreText(text: post.linkFlairText!.getValue(), style: context.textTheme.bodySmall),
            ),
            Gap.xSmall(),
          ],
          Expanded(
            child: VeryGoodCoreText(
              text: post.title.getValue(),
              style: context.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    ],
  );

  Color _getBackgroundColor(BuildContext context, Color linkFlairBackgroundColor) =>
      linkFlairBackgroundColor == AppColors.transparent
      ? context.colorScheme.secondary.withValues(alpha: 0.5)
      : linkFlairBackgroundColor;
}
