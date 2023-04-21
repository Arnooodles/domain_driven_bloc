import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/themes/spacing.dart';

class EmptyPost extends StatelessWidget {
  const EmptyPost({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Insets.large),
          color: context.colorScheme.background,
          width: Insets.infinity,
          height: context.screenHeight -
              AppTheme.defaultNavBarHeight -
              AppTheme.defaultAppBarHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.list_alt,
                  size: 200,
                  color: context.colorScheme.onBackground.withOpacity(0.25),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Insets.small,
                    bottom: Insets.xsmall,
                  ),
                  child: Text(
                    context.l10n.post__empty_post__empty_post_message,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.onBackground.withOpacity(0.25),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
