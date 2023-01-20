import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/route.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/l10n.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context).common_home.capitalize(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context).common_profile.capitalize(),
            ),
          ],
          currentIndex: _getSelectedIndex(context),
          onTap: (int index) => _onItemTapped(index, context),
        ),
      );

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouter.of(context).location;
    if (location.startsWith(RouteName.home.path)) {
      return 0;
    }
    if (location.startsWith(RouteName.profile.path)) {
      return 1;
    }

    return 0;
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