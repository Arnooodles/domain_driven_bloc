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
  /// If the controller doesn't exist, it will be automatically initialized
  ///
  /// Throws a [StateError] if no provider is found.
  static ScrollController of(BuildContext context, AppScrollController key) {
    final _InheritedScrollControllerProvider? provider = context
        .dependOnInheritedWidgetOfExactType<_InheritedScrollControllerProvider>();

    if (provider == null) {
      throw StateError(
        'ScrollControllerProvider.of() called with a context that does not contain a ScrollControllerProvider.',
      );
    }

    ScrollController? controller = provider.getController(key);

    // Auto-initialize controller if it doesn't exist
    if (controller == null && provider.onCreateController != null) {
      controller = provider.onCreateController!(key);
    }

    if (controller == null) {
      throw StateError('ScrollController for $key could not be created or retrieved.');
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

  /// Creates and adds a ScrollController for the given [key] if it doesn't exist.
  ///
  /// Returns the newly created or existing controller.
  ScrollController _getOrCreateController(AppScrollController key) {
    // Check if controller already exists
    if (_controllers.containsKey(key)) {
      return _controllers[key]!;
    } else {
      final ScrollController scrollController = ScrollController(debugLabel: key.name);
      _addController(key, scrollController);

      // Trigger rebuild to update InheritedWidget with the new controller
      // since we modified the _controllers map
      if (mounted) {
        setState(() {
          // Rebuild needed to notify InheritedWidget of controller addition
          assert(_controllers.containsKey(key), 'Controller should be added to map');
        });
      }

      return scrollController;
    }
  }

  void _onScrollChanged(ScrollController scrollController) {
    if (!scrollController.hasClients) return;
    late HidableCubit hidableCubit;
    try {
      hidableCubit = context.read<HidableCubit>();
    } on Exception catch (_) {
      return;
    }
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
  Widget build(BuildContext context) => _InheritedScrollControllerProvider(
    controllers: _controllers,
    onCreateController: _getOrCreateController,
    child: widget.child,
  );
}

/// InheritedWidget that provides ScrollControllers to descendant widgets.
class _InheritedScrollControllerProvider extends InheritedWidget {
  const _InheritedScrollControllerProvider({
    required this.controllers,
    required this.onCreateController,
    required super.child,
  });

  final Map<AppScrollController, ScrollController> controllers;
  final ScrollController Function(AppScrollController)? onCreateController;

  /// Retrieves the ScrollController for the given [key].
  ScrollController? getController(AppScrollController key) => controllers[key];

  @override
  bool updateShouldNotify(_InheritedScrollControllerProvider oldWidget) => controllers != oldWidget.controllers;
}
