import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/app_routes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/theme/theme_cubit.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_avatar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/cubit/auth/auth_cubit.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar extends StatelessWidget implements PreferredSizeWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar({
    super.key,
    this.title,
    this.titleColor,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.scrolledUnderElevation = _defaultElevation,
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

  static const double _defaultElevation = 2;

  @override
  Size get preferredSize => size ?? Size.fromHeight(AppTheme.defaultAppBarHeight);

  static List<Widget> buildCommonAppBarActions(BuildContext context) => <Widget>[
    IconButton(
      onPressed: () => context.read<ThemeCubit>().switchTheme(context.theme.brightness),
      icon: context.theme.brightness == Brightness.dark
          ? {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.light_mode))
          : {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.dark_mode)),
    ),
    BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) => state.maybeWhen(
        authenticated: (User user) => GestureDetector(
          onTap: () => const ProfileRoute().go(context),
          child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar(
            size: AppSizes.xLarge,
            imageUrl: user.image?.getValue(),
            padding: Paddings.allSmall,
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => AppBar(
    elevation: _defaultElevation,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    title: showTitle ? Padding(padding: Paddings.leftXSmall, child: Text(title ?? Constant.appName)) : null,
    actions: actions,
    scrolledUnderElevation: scrolledUnderElevation,
    backgroundColor: backgroundColor,
    centerTitle: centerTitle,
    bottom: bottom,
  );
}
