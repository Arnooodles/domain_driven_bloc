import 'package:flutter/material.dart';
import 'package:gap/gap.dart' as gap;
import 'package:very_good_core/app/themes/app_sizes.dart';

// ignore_for_file: prefer-match-file-name, avoid-returning-widgets
final class Gap extends StatelessWidget {
  const Gap(this._size, {super.key});

  factory Gap.xxSmall() => const Gap(AppSizes.xxSmall);
  factory Gap.xSmall() => const Gap(AppSizes.xSmall);
  factory Gap.small() => const Gap(AppSizes.small);
  factory Gap.medium() => const Gap(AppSizes.medium);
  factory Gap.large() => const Gap(AppSizes.large);
  factory Gap.xLarge() => const Gap(AppSizes.xLarge);
  factory Gap.xxLarge() => const Gap(AppSizes.xxLarge);
  factory Gap.xxxLarge() => const Gap(AppSizes.xxxLarge);

  final double _size;

  @override
  Widget build(BuildContext context) => gap.Gap(_size);
}

abstract final class Paddings {
  // all paddings
  static const EdgeInsets allXxSmall = EdgeInsets.all(AppSizes.xxSmall);
  static const EdgeInsets allXSmall = EdgeInsets.all(AppSizes.xSmall);
  static const EdgeInsets allSmall = EdgeInsets.all(AppSizes.small);
  static const EdgeInsets allMedium = EdgeInsets.all(AppSizes.medium);
  static const EdgeInsets allLarge = EdgeInsets.all(AppSizes.large);
  static const EdgeInsets allXLarge = EdgeInsets.all(AppSizes.xLarge);
  static const EdgeInsets allXxLarge = EdgeInsets.all(AppSizes.xxLarge);
  static const EdgeInsets allXxxLarge = EdgeInsets.all(AppSizes.xxxLarge);

  // horizontal paddings
  static const EdgeInsets horizontalXxSmall = EdgeInsets.symmetric(horizontal: AppSizes.xxSmall);
  static const EdgeInsets horizontalXSmall = EdgeInsets.symmetric(horizontal: AppSizes.xSmall);
  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(horizontal: AppSizes.small);
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: AppSizes.medium);
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(horizontal: AppSizes.large);
  static const EdgeInsets horizontalXLarge = EdgeInsets.symmetric(horizontal: AppSizes.xLarge);
  static const EdgeInsets horizontalXxLarge = EdgeInsets.symmetric(horizontal: AppSizes.xxLarge);
  static const EdgeInsets horizontalXxxLarge = EdgeInsets.symmetric(horizontal: AppSizes.xxxLarge);

  // vertical paddings
  static const EdgeInsets verticalXxSmall = EdgeInsets.symmetric(vertical: AppSizes.xxSmall);
  static const EdgeInsets verticalXSmall = EdgeInsets.symmetric(vertical: AppSizes.xSmall);
  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: AppSizes.small);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: AppSizes.medium);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: AppSizes.large);
  static const EdgeInsets verticalXLarge = EdgeInsets.symmetric(vertical: AppSizes.xLarge);
  static const EdgeInsets verticalXxLarge = EdgeInsets.symmetric(vertical: AppSizes.xxLarge);
  static const EdgeInsets verticalXxxLarge = EdgeInsets.symmetric(vertical: AppSizes.xxxLarge);

  // left paddings
  static const EdgeInsets leftXxSmall = EdgeInsets.only(left: AppSizes.xxSmall);
  static const EdgeInsets leftXSmall = EdgeInsets.only(left: AppSizes.xSmall);
  static const EdgeInsets leftSmall = EdgeInsets.only(left: AppSizes.small);
  static const EdgeInsets leftMedium = EdgeInsets.only(left: AppSizes.medium);
  static const EdgeInsets leftLarge = EdgeInsets.only(left: AppSizes.large);
  static const EdgeInsets leftXLarge = EdgeInsets.only(left: AppSizes.xLarge);
  static const EdgeInsets leftXxLarge = EdgeInsets.only(left: AppSizes.xxLarge);
  static const EdgeInsets leftXxxLarge = EdgeInsets.only(left: AppSizes.xxxLarge);

  // right paddings
  static const EdgeInsets rightXxSmall = EdgeInsets.only(right: AppSizes.xxSmall);
  static const EdgeInsets rightXSmall = EdgeInsets.only(right: AppSizes.xSmall);
  static const EdgeInsets rightSmall = EdgeInsets.only(right: AppSizes.small);
  static const EdgeInsets rightMedium = EdgeInsets.only(right: AppSizes.medium);
  static const EdgeInsets rightLarge = EdgeInsets.only(right: AppSizes.large);
  static const EdgeInsets rightXLarge = EdgeInsets.only(right: AppSizes.xLarge);
  static const EdgeInsets rightXxLarge = EdgeInsets.only(right: AppSizes.xxLarge);
  static const EdgeInsets rightXxxLarge = EdgeInsets.only(right: AppSizes.xxxLarge);

  // top paddings
  static const EdgeInsets topXxSmall = EdgeInsets.only(top: AppSizes.xxSmall);
  static const EdgeInsets topXSmall = EdgeInsets.only(top: AppSizes.xSmall);
  static const EdgeInsets topSmall = EdgeInsets.only(top: AppSizes.small);
  static const EdgeInsets topMedium = EdgeInsets.only(top: AppSizes.medium);
  static const EdgeInsets topLarge = EdgeInsets.only(top: AppSizes.large);
  static const EdgeInsets topXLarge = EdgeInsets.only(top: AppSizes.xLarge);
  static const EdgeInsets topXxLarge = EdgeInsets.only(top: AppSizes.xxLarge);
  static const EdgeInsets topXxxLarge = EdgeInsets.only(top: AppSizes.xxxLarge);

  // bottom paddings
  static const EdgeInsets bottomXxSmall = EdgeInsets.only(bottom: AppSizes.xxSmall);
  static const EdgeInsets bottomXSmall = EdgeInsets.only(bottom: AppSizes.xSmall);
  static const EdgeInsets bottomSmall = EdgeInsets.only(bottom: AppSizes.small);
  static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: AppSizes.medium);
  static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: AppSizes.large);
  static const EdgeInsets bottomXLarge = EdgeInsets.only(bottom: AppSizes.xLarge);
  static const EdgeInsets bottomXxLarge = EdgeInsets.only(bottom: AppSizes.xxLarge);
  static const EdgeInsets bottomXxxLarge = EdgeInsets.only(bottom: AppSizes.xxxLarge);
}
