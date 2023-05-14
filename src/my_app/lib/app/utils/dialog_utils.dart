import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:very_good_core/app/generated/l10n.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_dialogs.dart';

// ignore_for_file: long-method,long-parameter-list
final class DialogUtils {
  DialogUtils._();

  static Future<bool> showExitDialog(BuildContext context) async =>
      await DialogUtils.showConfirmationDialog(
        context,
        message: AppLocalizations.of(context).dialog__message__exit_message,
        onPositivePressed: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
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
  }) =>
      showModal<bool?>(
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
  }) =>
      context.showFlash<void>(
        duration: duration ?? const Duration(seconds: 3),
        builder: (BuildContext context, FlashController<void> controller) =>
            FlashBar<void>(
          controller: controller,
          backgroundColor: context.colorScheme.background,
          surfaceTintColor: context.colorScheme.surfaceTint,
          shouldIconPulse: false,
          position: position ?? FlashPosition.bottom,
          behavior: FlashBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.defaultBoardRadius,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: Insets.xxxlarge,
            horizontal: Insets.xxlarge,
          ),
          clipBehavior: Clip.antiAlias,
          icon: Padding(
            padding:
                const EdgeInsets.only(left: Insets.small, right: Insets.xsmall),
            child: icon ??
                Icon(
                  Icons.error_outline,
                  color: context.colorScheme.error,
                ),
          ),
          content: Text(
            message,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.colorScheme.onBackground),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      );
}
