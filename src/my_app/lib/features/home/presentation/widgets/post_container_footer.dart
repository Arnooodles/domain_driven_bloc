import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';

class PostContainerFooter extends StatelessWidget {
  const PostContainerFooter({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          _FooterItems(
            leftIcon: Icons.arrow_upward_rounded,
            value: post.upvotes.getOrCrash() == 0
                ? context.l10n.post__upvotes_default_value__vote
                : post.upvotes.getOrCrash().toString(),
            rightIcon: Icons.arrow_downward_rounded,
          ),
          _FooterItems(
            leftIcon: Icons.chat_bubble_outline,
            value: post.comments.getOrCrash().toString(),
          ),
        ],
      );
}

class _FooterItems extends StatelessWidget {
  const _FooterItems({
    required this.leftIcon,
    required this.value,
    this.rightIcon,
  });

  final IconData leftIcon;
  final IconData? rightIcon;

  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xsmall),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.outline,
          ),
          borderRadius: AppTheme.defaultBoardRadius,
        ),
        margin: const EdgeInsets.symmetric(horizontal: Insets.xxsmall),
        child: Row(
          children: <Widget>[
            Icon(
              leftIcon,
              size: (context.textTheme.bodySmall?.fontSize ?? 14) * 1.5,
              color: context.colorScheme.onSecondaryContainer,
            ),
            Padding(
              padding: const EdgeInsets.all(Insets.xsmall),
              child: Text(
                value,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            if (rightIcon != null)
              Icon(
                rightIcon,
                size: (context.textTheme.bodySmall?.fontSize ?? 14) * 1.5,
                color: context.colorScheme.onSecondaryContainer,
              ),
          ],
        ),
      );
}
