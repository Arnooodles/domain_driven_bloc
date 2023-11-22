import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/core/presentation/widgets/connectivity_checker.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_nav_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async =>
            DialogUtils.showExitDialog(context),
        child: ConnectivityChecker.scaffold(
          body: Center(
            child: navigationShell,
          ),
          bottomNavigationBar: VeryGoodCoreNavBar(
            navigationShell: navigationShell,
          ),
          backgroundColor: context.colorScheme.background,
        ),
      );
}
