import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/hidable/hidable_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_nav_bar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/connectivity_checker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _initScrollControllers() {
    final Map<AppScrollController, ScrollController> controllers =
        <AppScrollController, ScrollController>{};
    for (final AppScrollController appScrollController
        in AppScrollController.values) {
      final ScrollController scrollController =
          ScrollController(debugLabel: appScrollController.name);
      scrollController.addListener(
        () => _addListener(scrollController, context.read<HidableBloc>()),
      );
      controllers.putIfAbsent(appScrollController, () => scrollController);
    }
    context.read<AppCoreBloc>().setScrollControllers(controllers);
  }

  void _addListener(
    ScrollController scrollController,
    HidableBloc hidableBloc,
  ) {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      hidableBloc.setVisibility(isVisible: true);
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      hidableBloc.setVisibility(isVisible: false);
    }
  }

  void _onPopInvoked(bool didPop) {
    if (!didPop) {
      if (widget.navigationShell.currentIndex != 0) {
        widget.navigationShell.goBranch(0);
      } else {
        DialogUtils.showExitDialog(context);
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
          bottomNavigationBar: {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar(
            navigationShell: widget.navigationShell,
          ),
        ),
      );
}
