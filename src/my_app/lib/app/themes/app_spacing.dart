import 'package:flutter/material.dart';
import 'package:gap/gap.dart' as gap;

// ignore_for_file: prefer-match-file-name, avoid-returning-widgets
final class Gap extends StatelessWidget {
  const Gap(this._size, {super.key});

  factory Gap.xxSmall() => const Gap(Insets.xxSmall);
  factory Gap.xSmall() => const Gap(Insets.xSmall);
  factory Gap.small() => const Gap(Insets.small);
  factory Gap.medium() => const Gap(Insets.medium);
  factory Gap.large() => const Gap(Insets.large);
  factory Gap.xLarge() => const Gap(Insets.xLarge);
  factory Gap.xxLarge() => const Gap(Insets.xxLarge);
  factory Gap.xxxLarge() => const Gap(Insets.xxxLarge);

  final double _size;

  @override
  Widget build(BuildContext context) => gap.Gap(_size);
}

abstract final class Insets {
  const Insets._();

  static const double scale = 1;
  // Regular paddings
  static const double zero = 0;
  static const double xxSmall = scale * 4;
  static const double xSmall = scale * 8;
  static const double small = scale * 12;
  static const double medium = scale * 16;
  static const double large = scale * 24;
  static const double xLarge = scale * 32;
  static const double xxLarge = scale * 48;
  static const double xxxLarge = scale * 64;
  static const double infinity = double.infinity;
}

abstract final class Paddings {
  // all paddings
  static const EdgeInsets allXxSmall = EdgeInsets.all(Insets.xxSmall);
  static const EdgeInsets allXSmall = EdgeInsets.all(Insets.xSmall);
  static const EdgeInsets allSmall = EdgeInsets.all(Insets.small);
  static const EdgeInsets allMedium = EdgeInsets.all(Insets.medium);
  static const EdgeInsets allLarge = EdgeInsets.all(Insets.large);
  static const EdgeInsets allXLarge = EdgeInsets.all(Insets.xLarge);
  static const EdgeInsets allXxLarge = EdgeInsets.all(Insets.xxLarge);
  static const EdgeInsets allXxxLarge = EdgeInsets.all(Insets.xxxLarge);

  // horizontal paddings
  static const EdgeInsets horizontalXxSmall =
      EdgeInsets.symmetric(horizontal: Insets.xxSmall);
  static const EdgeInsets horizontalXSmall =
      EdgeInsets.symmetric(horizontal: Insets.xSmall);
  static const EdgeInsets horizontalSmall =
      EdgeInsets.symmetric(horizontal: Insets.small);
  static const EdgeInsets horizontalMedium =
      EdgeInsets.symmetric(horizontal: Insets.medium);
  static const EdgeInsets horizontalLarge =
      EdgeInsets.symmetric(horizontal: Insets.large);
  static const EdgeInsets horizontalXLarge =
      EdgeInsets.symmetric(horizontal: Insets.xLarge);
  static const EdgeInsets horizontalXxLarge =
      EdgeInsets.symmetric(horizontal: Insets.xxLarge);
  static const EdgeInsets horizontalXxxLarge =
      EdgeInsets.symmetric(horizontal: Insets.xxxLarge);

  // vertical paddings
  static const EdgeInsets verticalXxSmall =
      EdgeInsets.symmetric(vertical: Insets.xxSmall);
  static const EdgeInsets verticalXSmall =
      EdgeInsets.symmetric(vertical: Insets.xSmall);
  static const EdgeInsets verticalSmall =
      EdgeInsets.symmetric(vertical: Insets.small);
  static const EdgeInsets verticalMedium =
      EdgeInsets.symmetric(vertical: Insets.medium);
  static const EdgeInsets verticalLarge =
      EdgeInsets.symmetric(vertical: Insets.large);
  static const EdgeInsets verticalXLarge =
      EdgeInsets.symmetric(vertical: Insets.xLarge);
  static const EdgeInsets verticalXxLarge =
      EdgeInsets.symmetric(vertical: Insets.xxLarge);
  static const EdgeInsets verticalXxxLarge =
      EdgeInsets.symmetric(vertical: Insets.xxxLarge);

  // left paddings
  static const EdgeInsets leftXxSmall = EdgeInsets.only(left: Insets.xxSmall);
  static const EdgeInsets leftXSmall = EdgeInsets.only(left: Insets.xSmall);
  static const EdgeInsets leftSmall = EdgeInsets.only(left: Insets.small);
  static const EdgeInsets leftMedium = EdgeInsets.only(left: Insets.medium);
  static const EdgeInsets leftLarge = EdgeInsets.only(left: Insets.large);
  static const EdgeInsets leftXLarge = EdgeInsets.only(left: Insets.xLarge);
  static const EdgeInsets leftXxLarge = EdgeInsets.only(left: Insets.xxLarge);
  static const EdgeInsets leftXxxLarge = EdgeInsets.only(left: Insets.xxxLarge);

  // right paddings
  static const EdgeInsets rightXxSmall = EdgeInsets.only(right: Insets.xxSmall);
  static const EdgeInsets rightXSmall = EdgeInsets.only(right: Insets.xSmall);
  static const EdgeInsets rightSmall = EdgeInsets.only(right: Insets.small);
  static const EdgeInsets rightMedium = EdgeInsets.only(right: Insets.medium);
  static const EdgeInsets rightLarge = EdgeInsets.only(right: Insets.large);
  static const EdgeInsets rightXLarge = EdgeInsets.only(right: Insets.xLarge);
  static const EdgeInsets rightXxLarge = EdgeInsets.only(right: Insets.xxLarge);
  static const EdgeInsets rightXxxLarge =
      EdgeInsets.only(right: Insets.xxxLarge);

  // top paddings
  static const EdgeInsets topXxSmall = EdgeInsets.only(top: Insets.xxSmall);
  static const EdgeInsets topXSmall = EdgeInsets.only(top: Insets.xSmall);
  static const EdgeInsets topSmall = EdgeInsets.only(top: Insets.small);
  static const EdgeInsets topMedium = EdgeInsets.only(top: Insets.medium);
  static const EdgeInsets topLarge = EdgeInsets.only(top: Insets.large);
  static const EdgeInsets topXLarge = EdgeInsets.only(top: Insets.xLarge);
  static const EdgeInsets topXxLarge = EdgeInsets.only(top: Insets.xxLarge);
  static const EdgeInsets topXxxLarge = EdgeInsets.only(top: Insets.xxxLarge);

  // bottom paddings
  static const EdgeInsets bottomXxSmall =
      EdgeInsets.only(bottom: Insets.xxSmall);
  static const EdgeInsets bottomXSmall = EdgeInsets.only(bottom: Insets.xSmall);
  static const EdgeInsets bottomSmall = EdgeInsets.only(bottom: Insets.small);
  static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: Insets.medium);
  static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: Insets.large);
  static const EdgeInsets bottomXLarge = EdgeInsets.only(bottom: Insets.xLarge);
  static const EdgeInsets bottomXxLarge =
      EdgeInsets.only(bottom: Insets.xxLarge);
  static const EdgeInsets bottomXxxLarge =
      EdgeInsets.only(bottom: Insets.xxxLarge);
}
