import 'package:flutter/material.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/app/themes/text_styles.dart';
import 'package:very_good_core/app/utils/extensions.dart';
import 'package:very_good_core/app/utils/shimmer.dart';

class PostContainerLoading extends StatelessWidget {
  const PostContainerLoading({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.sm),
          child: PostContainerLoadingItem(delay: index * 300),
        ),
        separatorBuilder: (BuildContext context, int index) =>
            VSpace(Insets.sm),
        itemCount: 8,
      );
}

class PostContainerLoadingItem extends StatelessWidget {
  const PostContainerLoadingItem({
    super.key,
    required this.delay,
  });

  final int delay;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: AppTheme.defaultBoardRadius,
        ),
        child: Padding(
          padding: EdgeInsets.all(Insets.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _HeaderLoading(delay: delay),
              Padding(
                padding: EdgeInsets.all(Insets.xs),
                child: Shimmer(
                  millisecondsDelay: delay,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              _FooterLoading(delay: delay),
            ],
          ),
        ),
      );
}

class _HeaderLoading extends StatelessWidget {
  const _HeaderLoading({
    required this.delay,
  });

  final int delay;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(Insets.xs),
            child: Shimmer(
              millisecondsDelay: delay,
              width: context.screenWidth * 0.4,
              height: AppTextStyle.bodySmall.fontSize ?? 12,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Insets.xxs,
              horizontal: Insets.xs,
            ),
            child: Shimmer(
              millisecondsDelay: delay,
              width: double.infinity,
              height: AppTextStyle.titleMedium.fontSize ?? 16,
            ),
          ),
        ],
      );
}

class _FooterLoading extends StatelessWidget {
  const _FooterLoading({
    required this.delay,
  });

  final int delay;

  @override
  Widget build(BuildContext context) {
    final double footerHeight =
        (AppTextStyle.bodySmall.fontSize ?? 14) * 1.5 + Insets.sm;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.xs),
      margin: EdgeInsets.symmetric(horizontal: Insets.xxs),
      child: Row(
        children: <Widget>[
          Shimmer(
            millisecondsDelay: delay,
            width: 50,
            height: footerHeight,
          ),
          Padding(
            padding: EdgeInsets.all(Insets.xs),
            child: Shimmer(
              millisecondsDelay: delay,
              width: 50,
              height: footerHeight,
            ),
          ),
        ],
      ),
    );
  }
}
