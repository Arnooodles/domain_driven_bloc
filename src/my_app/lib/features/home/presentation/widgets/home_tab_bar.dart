import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_colors.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          _TabItem(
            label: 'r/FlutterDev',
            index: 0,
            currentIndex: navigationShell.currentIndex,
            onTap: () => _onTabTap(0),
          ),
          _TabItem(
            label: 'r/dartlang',
            index: 1,
            currentIndex: navigationShell.currentIndex,
            onTap: () => _onTabTap(1),
          ),
        ],
      );

  void _onTabTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(Insets.small),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: currentIndex == index
                      ? context.colorScheme.primary
                      : AppColors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                color: currentIndex == index
                    ? context.colorScheme.primary
                    : context.colorScheme.secondary,
              ),
            ),
          ),
        ),
      );
}
