import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/routes/route_name.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_avatar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

class VeryGoodCoreAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Size get preferredSize => size ?? Size.fromHeight(AppTheme.defaultAppBarHeight);

  static List<Widget> buildCommonAppBarActions(BuildContext context) => <Widget>[
    IconButton(
      onPressed: () => context.read<ThemeBloc>().switchTheme(Theme.of(context).brightness),
      icon: Theme.of(context).brightness == Brightness.dark
          ? VeryGoodCoreIcon(icon: right(Icons.light_mode))
          : VeryGoodCoreIcon(icon: right(Icons.dark_mode)),
    ),
    BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) => state.maybeWhen(
        authenticated: (User user) => GestureDetector(
          onTap: () => GoRouter.of(context).goNamed(RouteName.profile.name),
          child: VeryGoodCoreAvatar(size: 32, imageUrl: user.image?.getValue(), padding: Paddings.allSmall),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => AppBar(
    elevation: 2,
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
