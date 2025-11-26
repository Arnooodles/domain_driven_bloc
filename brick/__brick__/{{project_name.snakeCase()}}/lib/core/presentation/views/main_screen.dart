import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_nav_bar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/scroll_controller_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  Future<void> _onPopInvoked(BuildContext context, bool didPop) async {
    if (!didPop) {
      if (navigationShell.currentIndex != 0) {
        navigationShell.goBranch(0);
      } else {
        await DialogUtils.showExitDialog(context);
        if (!context.mounted) return;
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (bool didPop, _) => _onPopInvoked(context, didPop),
    child: ScrollControllerProvider(
      child: ConnectivityChecker.scaffold(
        body: navigationShell,
        bottomNavigationBar: {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar(navigationShell: navigationShell),
      ),
    ),
  );
}
