import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/hidable_controller.dart';

extension HidableControllerExt on ScrollController {
  static final Map<int, HidableController> hidableControllers =
      <int, HidableController>{};

  /// Shortcut way of creating hidable controller
  HidableController hidable(double size) {
    // If the same instance was created before, we should keep using it.
    if (hidableControllers.containsKey(hashCode)) {
      return hidableControllers[hashCode]!;
    }

    return hidableControllers[hashCode] = HidableController(
      scrollController: this,
      size: size,
    );
  }
}
