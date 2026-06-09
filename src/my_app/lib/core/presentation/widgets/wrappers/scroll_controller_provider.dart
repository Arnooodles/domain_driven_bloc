import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:very_good_core/core/domain/cubit/hidable/hidable_cubit.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';

/// Provider widget that manages ScrollController instances for the app.
///
/// This widget ensures proper lifecycle management of ScrollControllers
/// by creating them in initState and disposing them in dispose.
///
/// Controllers are provided to descendant widgets via [ScrollControllerProvider.of].
class ScrollControllerProvider extends HookWidget {
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
  Widget build(BuildContext context) {
    final Map<AppScrollController, ScrollController> controllers = useMemoized(
      () => <AppScrollController, ScrollController>{},
      <Object?>[],
    );

    useEffect(
      () {
        final Map<AppScrollController, VoidCallback> listeners = <AppScrollController, VoidCallback>{};

        for (final AppScrollController appScrollController in AppScrollController.values) {
          final ScrollController scrollController = ScrollController(debugLabel: appScrollController.name);

          void listener() {
            if (!scrollController.hasClients || !context.mounted) return;
            final HidableCubit hidableCubit = context.read<HidableCubit>();
            final ScrollDirection direction = scrollController.position.userScrollDirection;

            if (direction == ScrollDirection.forward) {
              hidableCubit.setVisibility(isVisible: true);
            } else if (direction == ScrollDirection.reverse) {
              hidableCubit.setVisibility(isVisible: false);
            }
          }

          scrollController.addListener(listener);
          controllers[appScrollController] = scrollController;
          listeners[appScrollController] = listener;
        }

        return () {
          for (final MapEntry<AppScrollController, ScrollController> entry in controllers.entries) {
            final ScrollController controller = entry.value;
            final VoidCallback? listener = listeners[entry.key];
            if (listener != null) {
              controller.removeListener(listener);
            }
            controller.dispose();
          }
          controllers.clear();
          listeners.clear();
        };
      },
      <Object?>[],
    );

    return _InheritedScrollControllerProvider(controllers: controllers, child: child);
  }
}

/// InheritedWidget that provides ScrollControllers to descendant widgets.
class _InheritedScrollControllerProvider extends InheritedWidget {
  const _InheritedScrollControllerProvider({required this.controllers, required super.child});

  final Map<AppScrollController, ScrollController> controllers;

  /// Retrieves the ScrollController for the given [key].
  ScrollController? getController(AppScrollController key) => controllers[key];

  @override
  bool updateShouldNotify(_InheritedScrollControllerProvider oldWidget) => controllers != oldWidget.controllers;
}
