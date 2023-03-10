import 'package:dartx/dartx.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hidable/hidable.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/route.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/utils/extensions.dart';

class VeryGoodCoreNavBar extends StatelessWidget {
  const VeryGoodCoreNavBar({
    super.key,
    required this.scrollControllers,
  });

  final Map<AppScrollController, ScrollController> scrollControllers;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Hidable(
          controller: _getSelectedPage(context).value2,
          preferredWidgetSize:
              const Size.fromHeight(AppTheme.defaultNavBarHeight),
          child: NavigationBar(
            selectedIndex: _getSelectedPage(context).value1,
            destinations: <Widget>[
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: context.l10n.common_home.capitalize(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_circle_outlined),
                selectedIcon: const Icon(Icons.account_circle),
                label: context.l10n.common_profile.capitalize(),
              ),
            ],
            onDestinationSelected: (int index) => _onItemTapped(index, context),
          ),
        ),
      );

  Tuple2<int, ScrollController> _getSelectedPage(BuildContext context) {
    final String location = GoRouter.of(context).location;
    if (location.startsWith(RouteName.home.path)) {
      return Tuple2<int, ScrollController>(
        0,
        scrollControllers[AppScrollController.home]!,
      );
    }
    if (location.startsWith(RouteName.profile.path)) {
      return Tuple2<int, ScrollController>(
        1,
        scrollControllers[AppScrollController.profile]!,
      );
    }

    return Tuple2<int, ScrollController>(
      0,
      scrollControllers[AppScrollController.home]!,
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).goNamed(RouteName.home.name);
        break;
      case 1:
        GoRouter.of(context).goNamed(RouteName.profile.name);
        break;
      default:
        GoRouter.of(context).goNamed(RouteName.home.name);
    }
  }
}
