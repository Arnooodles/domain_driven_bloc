import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/core/domain/cubit/app_core/app_core_cubit.dart';
import 'package:very_good_core/core/domain/cubit/hidable/hidable_cubit.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_nav_bar.dart';
import 'package:very_good_core/core/presentation/widgets/wrappers/connectivity_checker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Map<AppScrollController, ScrollController> _controllers = <AppScrollController, ScrollController>{};

  void _initScrollControllers() {
    for (final AppScrollController appScrollController in AppScrollController.values) {
      final ScrollController scrollController = ScrollController(debugLabel: appScrollController.name);
      // ignore: always-remove-listener
      scrollController.addListener(() => _addListener(scrollController, context.read<HidableCubit>()));
      _controllers.putIfAbsent(appScrollController, () => scrollController);
    }
    context.read<AppCoreCubit>().setScrollControllers(_controllers);
  }

  void _addListener(ScrollController scrollController, HidableCubit hidableCubit) {
    if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      hidableCubit.setVisibility(isVisible: true);
    } else if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      hidableCubit.setVisibility(isVisible: false);
    }
  }

  Future<void> _onPopInvoked(bool didPop) async {
    if (!didPop) {
      if (widget.navigationShell.currentIndex != 0) {
        widget.navigationShell.goBranch(0);
      } else {
        await DialogUtils.showExitDialog(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initScrollControllers();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (bool didPop, _) => _onPopInvoked(didPop),
    child: ConnectivityChecker.scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: VeryGoodCoreNavBar(navigationShell: widget.navigationShell),
    ),
  );

  @override
  void dispose() {
    _controllers.forEach((AppScrollController key, ScrollController scrollController) {
      scrollController
        ..removeListener(() => _addListener(scrollController, context.read<HidableCubit>()))
        ..dispose();
    });

    super.dispose();
  }
}
