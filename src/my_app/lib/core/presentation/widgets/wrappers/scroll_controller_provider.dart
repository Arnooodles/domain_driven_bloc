import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_core/core/domain/cubit/hidable/hidable_cubit.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';

/// Provider widget that manages ScrollController instances for the app.
///
/// This widget ensures proper lifecycle management of ScrollControllers
/// by creating them in initState and disposing them in dispose.
///
/// Controllers are provided to descendant widgets via [ScrollControllerProvider.of].
class ScrollControllerProvider extends StatefulWidget {
  const ScrollControllerProvider({required this.child, super.key});

  final Widget child;

  /// Retrieves the ScrollController for the given [key] from the nearest
  /// [ScrollControllerProvider] ancestor.
  ///
  /// Throws a [StateError] if no provider is found or if the controller
  /// for the given [key] has not been initialized.
  static ScrollController of(BuildContext context, AppScrollController key) {
    final _InheritedScrollControllerProvider? provider = context
        .dependOnInheritedWidgetOfExactType<_InheritedScrollControllerProvider>();

    if (provider == null) {
      throw StateError(
        'ScrollControllerProvider.of() called with a context that does not contain a ScrollControllerProvider.',
      );
    }

    final ScrollController? controller = provider.getController(key);

    if (controller == null) {
      throw StateError('ScrollController for $key not found. Ensure it is initialized in ScrollControllerProvider.');
    }

    return controller;
  }

  @override
  State<ScrollControllerProvider> createState() => _ScrollControllerProviderState();
}

class _ScrollControllerProviderState extends State<ScrollControllerProvider> {
  final Map<AppScrollController, ScrollController> _controllers = <AppScrollController, ScrollController>{};
  final Map<AppScrollController, VoidCallback> _listeners = <AppScrollController, VoidCallback>{};

  void _initScrollControllers() {
    for (final AppScrollController appScrollController in AppScrollController.values) {
      final ScrollController scrollController = ScrollController(debugLabel: appScrollController.name);
      _addController(appScrollController, scrollController);
    }
  }

  void _addController(AppScrollController appScrollController, ScrollController scrollController) {
    void listener() => _onScrollChanged(scrollController);
    // ignore: always-remove-listener
    scrollController.addListener(listener);
    _controllers.putIfAbsent(appScrollController, () => scrollController);
    _listeners.putIfAbsent(appScrollController, () => listener);
  }

  void _onScrollChanged(ScrollController scrollController) {
    if (!scrollController.hasClients) return;
    final HidableCubit hidableCubit = context.read<HidableCubit>();
    final ScrollDirection direction = scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.forward) {
      hidableCubit.setVisibility(isVisible: true);
    } else if (direction == ScrollDirection.reverse) {
      hidableCubit.setVisibility(isVisible: false);
    }
  }

  void _disposeScrollControllers() {
    for (final MapEntry<AppScrollController, ScrollController> entry in _controllers.entries) {
      final ScrollController controller = entry.value;
      final VoidCallback? listener = _listeners[entry.key];
      if (listener != null) {
        controller.removeListener(listener);
      }
      controller.dispose();
    }
    _controllers.clear();
    _listeners.clear();
  }

  @override
  void initState() {
    super.initState();
    _initScrollControllers();
  }

  @override
  void dispose() {
    _disposeScrollControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _InheritedScrollControllerProvider(controllers: _controllers, child: widget.child);
}

/// InheritedWidget that provides ScrollControllers to descendant widgets.
class _InheritedScrollControllerProvider extends InheritedWidget {
  const _InheritedScrollControllerProvider({required this.controllers, required super.child});

  final Map<AppScrollController, ScrollController> controllers;

  /// Retrieves the ScrollController for the given [key].
  ScrollController? getController(AppScrollController key) => controllers[key];

  @override
  bool updateShouldNotify(_InheritedScrollControllerProvider oldWidget) => true;
}
