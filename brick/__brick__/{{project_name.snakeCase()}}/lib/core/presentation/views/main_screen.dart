import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/hidable/hidable_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_nav_bar.dart';

class MainScreen extends HookWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _initScrollControllers(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        _initScrollControllers(context);
        return null;
      },
      <Object?>[],
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async => DialogUtils.showExitDialog(context),
      child: ConnectivityChecker.scaffold(
        body: Center(
          child: navigationShell,
        ),
        bottomNavigationBar: {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar(
          navigationShell: navigationShell,
        ),
        backgroundColor: context.colorScheme.background,
      ),
    );
  }
}
