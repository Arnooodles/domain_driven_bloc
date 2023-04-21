import 'package:flutter/material.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/themes/app_text_style.dart';
import 'package:very_good_core/app/themes/spacing.dart';

class VeryGoodCoreAppBar extends StatelessWidget {
  const VeryGoodCoreAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.scrolledUnderElevation = 0,
    this.showTitle = true,
  });

  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double scrolledUnderElevation;
  final bool showTitle;

  @override
  Widget build(BuildContext context) => AppBar(
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: showTitle
            ? Padding(
                padding: const EdgeInsets.only(left: Insets.xsmall),
                child: Text(
                  title ?? Constant.appName,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: titleColor,
                    fontWeight: AppFontWeight.medium,
                  ),
                ),
              )
            : null,
        actions: actions,
        scrolledUnderElevation: scrolledUnderElevation,
        backgroundColor: backgroundColor ?? context.colorScheme.background,
        centerTitle: centerTitle,
      );
}
