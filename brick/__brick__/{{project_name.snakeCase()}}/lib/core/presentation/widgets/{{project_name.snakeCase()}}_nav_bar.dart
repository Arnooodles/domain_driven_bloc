// ignore_for_file: invalid_use_of_protected_member

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/hidable.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar extends HookWidget implements PreferredSizeWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar({required this.navigationShell, this.size, super.key});

  final StatefulNavigationShell navigationShell;
  final Size? size;

  @override
  Size get preferredSize => size ?? const Size.fromHeight(AppTheme.defaultNavBarHeight);

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 800),
    child: Hidable(
      child: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.home_outlined)),
            selectedIcon: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.home)),
            label: context.i18n.common.home.capitalize(),
          ),
          NavigationDestination(
            icon: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.account_circle_outlined)),
            selectedIcon: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.account_circle)),
            label: context.i18n.common.profile.capitalize(),
          ),
        ],
        onDestinationSelected: (int index) => _onItemTapped(context, index),
      ),
    ),
  );

  void _onItemTapped(BuildContext context, int index) {
    if (index != navigationShell.currentIndex) {
      navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
    }
  }
}
