import 'package:flutter/material.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';

class VeryGoodCoreAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const VeryGoodCoreAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.scrolledUnderElevation = 2,
    this.showTitle = true,
    this.bottom,
    this.size,
  });

  final String? title;
  final Size? size;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;
  final double scrolledUnderElevation;
  final bool showTitle;

  @override
  Size get preferredSize =>
      size ?? Size.fromHeight(AppTheme.defaultAppBarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        elevation: 2,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: showTitle
            ? Padding(
                padding: Paddings.leftXSmall,
                child: Text(
                  title ?? Constant.appName,
                ),
              )
            : null,
        actions: actions,
        scrolledUnderElevation: scrolledUnderElevation,
        backgroundColor: backgroundColor,
        centerTitle: centerTitle,
        bottom: bottom,
      );
}
