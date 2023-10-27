import 'package:flutter/material.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/presentation/widgets/shimmer.dart';

class PostContainerLoading extends StatelessWidget {
  const PostContainerLoading({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.small),
          child: _PostContainerLoadingItem(delay: index * 300),
        ),
        separatorBuilder: (BuildContext context, int index) =>
            const VSpace(Insets.small),
        itemCount: 5,
      );
}

class _PostContainerLoadingItem extends StatelessWidget {
  const _PostContainerLoadingItem({
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
          padding: const EdgeInsets.all(Insets.xsmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _HeaderLoading(delay: delay),
              Padding(
                padding: const EdgeInsets.all(Insets.xsmall),
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
            padding: const EdgeInsets.all(Insets.xsmall),
            child: Shimmer(
              millisecondsDelay: delay,
              width: Constant.mobileBreakpoint * 0.4,
              height: context.textTheme.bodySmall?.fontSize ?? 12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Insets.xxsmall,
              horizontal: Insets.xsmall,
            ),
            child: Shimmer(
              millisecondsDelay: delay,
              width: double.infinity,
              height: context.textTheme.titleMedium?.fontSize ?? 16,
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
        (context.textTheme.bodySmall?.fontSize ?? 14) * 1.5 + Insets.small;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.xsmall),
      margin: const EdgeInsets.symmetric(horizontal: Insets.xxsmall),
      child: Row(
        children: <Widget>[
          Shimmer(
            millisecondsDelay: delay,
            width: 50,
            height: footerHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(Insets.xsmall),
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
