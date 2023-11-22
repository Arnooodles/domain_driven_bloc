import 'package:flutter/material.dart';
import 'package:gap/gap.dart' as gap;

// ignore_for_file: prefer-match-file-name, avoid-returning-widgets
final class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  factory Gap.xxsmall() => const Gap(Insets.xxsmall);
  factory Gap.xsmall() => const Gap(Insets.xsmall);
  factory Gap.small() => const Gap(Insets.small);
  factory Gap.medium() => const Gap(Insets.medium);
  factory Gap.large() => const Gap(Insets.large);
  factory Gap.xlarge() => const Gap(Insets.xlarge);
  factory Gap.xxlarge() => const Gap(Insets.xxlarge);
  factory Gap.xxxlarge() => const Gap(Insets.xxxlarge);

  final double size;

  @override
  Widget build(BuildContext context) => gap.Gap(size);
}

final class Insets {
  const Insets._();

  static const double scale = 1;
  // Regular paddings
  static const double zero = 0;
  static const double xxsmall = scale * 4;
  static const double xsmall = scale * 8;
  static const double small = scale * 12;
  static const double medium = scale * 16;
  static const double large = scale * 24;
  static const double xlarge = scale * 32;
  static const double xxlarge = scale * 48;
  static const double xxxlarge = scale * 64;
  static const double infinity = double.infinity;
}
