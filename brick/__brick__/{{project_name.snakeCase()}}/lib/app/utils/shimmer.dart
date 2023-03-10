import 'dart:async';

import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/extensions.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    this.millisecondsDelay = 0,
    this.radius = AppTheme.defaultRadius,
    this.highlightColor,
    this.baseColor,
    this.index = 0,
    required this.width,
    required this.height,
  });

  factory Shimmer.round({
    required double size,
    Color? highlightColor,
    int millisecondsDelay = 0,
    Color? baseColor,
  }) =>
      Shimmer(
        millisecondsDelay: millisecondsDelay,
        radius: size / 2,
        highlightColor: highlightColor,
        baseColor: baseColor,
        width: size,
        height: size,
      );

  final Color? highlightColor;
  final Color? baseColor;
  final double radius;
  final double width;
  final double height;
  final int millisecondsDelay;
  final int index;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> {
  late Timer periodicTimer;
  bool isHighLight = false;
  Timer? timer;

  Color getHighLightColor({required bool isDarkMode}) =>
      widget.highlightColor ??
      (isDarkMode //
          ? AppColors.darkShimmerHighlight
          : AppColors.lightShimmerHighlight);

  Color getBaseColor({required bool isDarkMode}) =>
      widget.baseColor ??
      (isDarkMode //
          ? AppColors.darkShimmerBase
          : AppColors.lightShimmerBase);

  @override
  void dispose() {
    timer?.cancel();
    periodicTimer.cancel();
    super.dispose();
  }

  void safeSetState() {
    if (mounted) {
      setState(() {
        isHighLight = !isHighLight;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => onHighlight(),
    );
  }

  void onHighlight() {
    if (widget.millisecondsDelay != 0) {
      timer = Timer(
        Duration(milliseconds: widget.millisecondsDelay),
        safeSetState,
      );
    } else {
      safeSetState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.isDarkMode;

    return AnimatedContainer(
      decoration: BoxDecoration(
        color: isHighLight
            ? getHighLightColor(isDarkMode: isDarkMode)
            : getBaseColor(isDarkMode: isDarkMode),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      width: widget.width,
      height: widget.height,
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
    );
  }
}
