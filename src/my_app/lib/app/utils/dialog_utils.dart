import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_sizes.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/utils/app_utils.dart';
import 'package:very_good_core/core/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

// ignore_for_file: long-method,long-parameter-list
final class DialogUtils {
  DialogUtils._();

  static Future<bool> showExitDialog(BuildContext context) async =>
      await DialogUtils.showConfirmationDialog(
        context,
        message: context.i18n.dialog.exit_message,
        onPositivePressed: AppUtils.closeApp,
      ) ??
      false;

  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String message,
    String? title,
    String? negativeButtonText,
    String? positiveButtonText,
    VoidCallback? onNegativePressed,
    VoidCallback? onPositivePressed,
    Color? negativeButtonColor,
    Color? positiveButtonColor,
    Color? negativeButtonTextColor,
    Color? positiveButtonTextColor,
    Color? titleColor,
  }) => showModal<bool?>(
    context: context,
    builder: (BuildContext context) => ConfirmationDialog(
      message: message,
      title: title,
      titleColor: titleColor,
      negativeButtonText: negativeButtonText,
      positiveButtonText: positiveButtonText,
      onNegativePressed: onNegativePressed,
      onPositivePressed: onPositivePressed,
      negativeButtonColor: negativeButtonColor,
      positiveButtonColor: positiveButtonColor,
      negativeButtonTextColor: negativeButtonTextColor,
      positiveButtonTextColor: positiveButtonTextColor,
    ),
  );

  static Future<void> showError(
    BuildContext context,
    String message, {
    Icon? icon,
    Duration? duration,
    FlashPosition? position,
  }) => context.showFlash<void>(
    duration: duration ?? const Duration(seconds: 3),
    builder: (BuildContext context, FlashController<void> controller) => FlashBar<void>(
      controller: controller,
      shouldIconPulse: false,
      position: position ?? FlashPosition.bottom,
      behavior: FlashBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: AppTheme.defaultBorderRadius),
      margin: const EdgeInsets.symmetric(vertical: AppSizes.xxxLarge, horizontal: AppSizes.xxLarge),
      clipBehavior: Clip.antiAlias,
      icon: Padding(
        padding: const EdgeInsets.only(left: AppSizes.small, right: AppSizes.xSmall),
        child: icon ?? VeryGoodCoreIcon(icon: right(Icons.error_outline), color: context.colorScheme.error),
      ),
      content: VeryGoodCoreText(
        text: message,
        style: context.textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    ),
  );
}
