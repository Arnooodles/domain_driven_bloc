import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_theme.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({
    required this.child,
    this.enabled = true,
    this.ignorePointers = false,
    this.justifyMultiLineText = true,
    this.textBoneBorderRadius = const TextBoneBorderRadius(AppTheme.defaultBorderRadius),
    this.containersColor,
    this.ignoreContainers,
    super.key,
  });

  final Widget child;
  final bool enabled;
  final bool ignorePointers;
  final bool justifyMultiLineText;
  final TextBoneBorderRadius? textBoneBorderRadius;
  final Color? containersColor;
  final bool? ignoreContainers;

  @override
  Widget build(BuildContext context) {
    final bool darkMode = context.isDarkMode;

    final Color baseColor = darkMode ? Colors.white24 : context.colorScheme.onSurface.withValues(alpha: 0.2);
    final Color highlightColor = darkMode ? Colors.white12 : context.colorScheme.onSurface.withValues(alpha: 0.1);

    return Skeletonizer(
      enabled: enabled,
      ignorePointers: ignorePointers,
      justifyMultiLineText: justifyMultiLineText,
      textBoneBorderRadius: textBoneBorderRadius,
      containersColor: containersColor,
      ignoreContainers: ignoreContainers,
      effect: ShimmerEffect(baseColor: baseColor, highlightColor: highlightColor, duration: const Duration(seconds: 1)),
      child: child,
    );
  }
}
