import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:toastification/toastification.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/themes/app_colors.dart';
import 'package:very_good_core/app/themes/app_sizes.dart';
import 'package:very_good_core/app/utils/app_utils.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';
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

  static ToastificationItem showError(
    String message, {
    Widget? icon,
    Duration? duration,
    bool isDismissable = true,
    Alignment alignment = Alignment.topCenter,
  }) => toastification.show(
    title: VeryGoodCoreText(text: message, overflow: TextOverflow.ellipsis, maxLines: 3),
    icon: Padding(
      padding: const EdgeInsets.only(left: AppSizes.small, right: AppSizes.xSmall),
      child: icon ?? VeryGoodCoreIcon(icon: right(Icons.error_outline)),
    ),
    autoCloseDuration: isDismissable ? duration ?? const Duration(seconds: 5) : null,
    style: ToastificationStyle.flatColored,
    type: ToastificationType.custom('app_error', _getErrorColor(), Icons.error_outline),
    alignment: alignment,
    closeOnClick: isDismissable,
    dragToClose: isDismissable,
    closeButton: isDismissable ? const ToastCloseButton() : const ToastCloseButton(showType: CloseButtonShowType.none),
    dismissDirection: isDismissable ? null : DismissDirection.none,
  );

  static Color _getErrorColor() => getIt<ThemeBloc>().state == ThemeMode.dark
      ? AppColors.darkColorScheme.errorContainer
      : AppColors.lightColorScheme.error;
}
