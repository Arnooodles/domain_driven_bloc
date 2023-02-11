import 'dart:io';

import 'package:animations/animations.dart';
import 'package:dartx/dartx.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/l10n.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/text_styles.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_dialogs.dart';

class DialogUtils {
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

  static Future<void>? showOfflineDialog<T>(
    BuildContext context, {
    Duration? duration,
  }) =>
      showFlash(
        context: context,
        builder: (BuildContext context, FlashController<void> controller) =>
            Flash<void>(
          controller: controller,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          position: FlashPosition.bottom,
          behavior: FlashBehavior.fixed,
          barrierDismissible: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.med),
            child: FlashBar(
              content: Text(
                ConnectionStatus.offline.name.capitalize(),
              ),
              icon: const Icon(
                Icons.wifi_off,
              ),
            ),
          ),
        ),
        duration: duration,
      );

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
  }) =>
      showModal<bool?>(
        context: context,
        builder: (BuildContext context) => ConfirmationDialog(
          message: message,
          title: title,
          negativeButtonText: negativeButtonText,
          positiveButtonText: positiveButtonText,
          onNegativePressed: onNegativePressed,
          onPositivePressed: onPositivePressed,
          negativeButtonColor: negativeButtonColor,
          positiveButtonColor: positiveButtonColor,
        ),
      );

  static Future<void> showToast(
    BuildContext context,
    String message, {
    Icon? icon,
    Duration? duration,
    FlashPosition? position,
  }) =>
      showFlash(
        context: context,
        builder: (
          BuildContext context,
          FlashController<Object?> controller,
        ) =>
            Flash<dynamic>.bar(
          controller: controller,
          margin: EdgeInsets.all(Insets.med),
          borderRadius: AppTheme.defaultBoardRadius,
          boxShadows: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1F000000),
              offset: Offset(0, 6),
              blurRadius: 16,
            ),
          ],
          position: position ?? FlashPosition.top,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Insets.med,
              horizontal: Insets.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: Insets.sm),
                    child: icon,
                  ),
                Flexible(
                  child: Text(
                    message,
                    style: AppTextStyle.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
        duration: duration ?? const Duration(seconds: 2),
      );
}
