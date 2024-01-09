import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_text_style.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar({
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
        bottom: bottom,
      );
}
