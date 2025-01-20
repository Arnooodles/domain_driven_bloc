// ignore_for_file: invalid_use_of_protected_member

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';
import 'package:very_good_core/core/presentation/widgets/wrappers/hidable.dart';

class VeryGoodCoreNavBar extends HookWidget implements PreferredSizeWidget {
  const VeryGoodCoreNavBar({
    required this.navigationShell,
    this.size,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final Size? size;

  @override
  Size get preferredSize =>
      size ?? const Size.fromHeight(AppTheme.defaultNavBarHeight);

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Hidable(
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            destinations: <Widget>[
              NavigationDestination(
                icon: VeryGoodCoreIcon(icon: right(Icons.home_outlined)),
                selectedIcon: VeryGoodCoreIcon(icon: right(Icons.home)),
                label: context.i18n.common.home.capitalize(),
              ),
              NavigationDestination(
                icon: VeryGoodCoreIcon(
                  icon: right(Icons.account_circle_outlined),
                ),
                selectedIcon:
                    VeryGoodCoreIcon(icon: right(Icons.account_circle)),
                label: context.i18n.common.profile.capitalize(),
              ),
            ],
            onDestinationSelected: (int index) => _onItemTapped(context, index),
          ),
        ),
      );

  void _onItemTapped(
    BuildContext context,
    int index,
  ) {
    if (index != navigationShell.currentIndex) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }
}
