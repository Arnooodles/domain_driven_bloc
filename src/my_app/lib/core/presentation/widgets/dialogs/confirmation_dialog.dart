import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/domain/entity/enum/button_type.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_button.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.message,
    this.title,
    this.titleColor,
    this.negativeButtonText,
    this.positiveButtonText,
    this.onNegativePressed,
    this.onPositivePressed,
    this.negativeButtonColor,
    this.positiveButtonColor,
    this.negativeButtonTextColor,
    this.positiveButtonTextColor,
    super.key,
  });

  final String message;
  final String? title;
  final Color? titleColor;
  final String? negativeButtonText;
  final String? positiveButtonText;
  final VoidCallback? onNegativePressed;
  final VoidCallback? onPositivePressed;
  final Color? negativeButtonColor;
  final Color? positiveButtonColor;
  final Color? negativeButtonTextColor;
  final Color? positiveButtonTextColor;

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: const RoundedRectangleBorder(borderRadius: AppTheme.defaultBorderRadius),
    title: title != null ? VeryGoodCoreText(text: title!, style: context.textTheme.titleMedium) : null,
    content: Padding(
      padding: title != null ? EdgeInsets.zero : Paddings.topXxSmall,
      child: VeryGoodCoreText(
        text: message,
        style: context.textTheme.bodyMedium?.copyWith(color: titleColor),
      ),
    ),
    actions: <Widget>[
      VeryGoodCoreButton(
        text: negativeButtonText ?? context.i18n.common.no.toUpperCase(),
        buttonType: ButtonType.text,
        onPressed: onNegativePressed ?? () => context.navigator.pop(),
        padding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        textStyle: TextStyle(color: negativeButtonTextColor ?? context.colorScheme.primary),
      ),
      VeryGoodCoreButton(
        text: positiveButtonText ?? context.i18n.common.yes.toUpperCase(),
        buttonType: ButtonType.text,
        onPressed: onPositivePressed ?? () => context.navigator.pop(),
        padding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        textStyle: TextStyle(color: positiveButtonTextColor ?? context.colorScheme.primary),
      ),
    ],
    actionsPadding: Paddings.horizontalMedium,
    buttonPadding: EdgeInsets.zero,
  );
}
