import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/helpers/hidable_controller.dart';

class Hidable extends StatelessWidget {
  const Hidable({
    required this.child,
    required this.controller,
    this.wOpacity = true,
    this.preferredWidgetSize = const Size.fromHeight(56),
    super.key,
  });

  final Widget child;
  final ScrollController controller;
  final bool wOpacity;
  final Size preferredWidgetSize;

  @override
  Widget build(BuildContext context) {
    final HidableController hidable =
        controller.hidable(preferredWidgetSize.height);

    return ValueListenableBuilder<bool>(
      valueListenable: hidable.stickinessNotifier,
      builder: (_, bool isStickinessEnabled, __) {
        // If stickiness of hidable was enabled, return card with one factor.
        // So, that hidable's movement would be disabled.
        if (isStickinessEnabled) return hidableCard(1, hidable);

        return ValueListenableBuilder<double>(
          valueListenable: hidable.sizeNotifier,
          builder: (_, double height, __) => hidableCard(height, hidable),
        );
      },
    );
  }

  Widget hidableCard(double factor, HidableController hidable) => Align(
        heightFactor: factor,
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: hidable.size,
          child: wOpacity ? Opacity(opacity: factor, child: child) : child,
        ),
      );
}
