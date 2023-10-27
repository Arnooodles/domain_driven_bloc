import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/extensions/go_router_ext.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/presentation/widgets/hidable.dart';

class VeryGoodCoreNavBar extends StatelessWidget {
  const VeryGoodCoreNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Hidable(
          controller: context
              .read<AppCoreBloc>()
              .getScrollController(context.goRouter.location),
          preferredWidgetSize:
              const Size.fromHeight(AppTheme.defaultNavBarHeight),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
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
            onDestinationSelected: _onItemTapped,
          ),
        ),
      );

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
