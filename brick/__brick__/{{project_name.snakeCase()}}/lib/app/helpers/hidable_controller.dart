import 'package:flutter/material.dart';

class HidableController {
  HidableController({
    required this.scrollController,
    required this.size,
  }) {
    scrollController.addListener(listener);
  }

  ScrollController scrollController;

  double size;
  double factor = 0;
  double lastOffset = 0;

  final ValueNotifier<double> sizeNotifier = ValueNotifier<double>(1);

  final ValueNotifier<bool> stickinessNotifier = ValueNotifier<bool>(false);

  set stickiness(bool state) => stickinessNotifier.value = state;

  bool get stickiness => stickinessNotifier.value;

  double sizeFactor() => 1.0 - (factor / size);

  void listener() {
    final ScrollPosition position = scrollController.position;

    factor = (factor + position.pixels - lastOffset).clamp(0.0, size);
    lastOffset = position.pixels;

    if (position.axisDirection == AxisDirection.down &&
        position.extentAfter == 0.0) {
      if (sizeNotifier.value == 0.0) return;

      sizeNotifier.value = 0.0;
      return;
    }

    if (position.axisDirection == AxisDirection.up &&
        position.extentBefore == 0.0) {
      if (sizeNotifier.value == 1.0) return;

      sizeNotifier.value = 1.0;
      return;
    }

    final bool isZeroValued = factor == 0.0 && sizeNotifier.value == 0.0;
    if (isZeroValued || (factor == size && sizeNotifier.value == 1.0)) return;

    sizeNotifier.value = sizeFactor();
  }

  void close() {
    stickinessNotifier.dispose();
    sizeNotifier.dispose();
  }
}
