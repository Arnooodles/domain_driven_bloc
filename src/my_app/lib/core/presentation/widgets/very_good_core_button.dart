import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/core/domain/entity/enum/button_type.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

class VeryGoodCoreButton extends StatelessWidget {
  const VeryGoodCoreButton({
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.isExpanded = false,
    this.buttonType = ButtonType.elevated,
    this.buttonStyle,
    this.textStyle,
    this.padding,
    this.contentPadding,
    this.icon,
    this.iconPadding,
    super.key,
  });

  final String text;
  final bool isEnabled;
  final bool isExpanded;
  final ButtonType buttonType;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final Widget? icon;
  final EdgeInsets? iconPadding;

  @override
  Widget build(BuildContext context) => Semantics(
        key: Key(text),
        enabled: isEnabled,
        button: true,
        label: text,
        child: SizedBox(
          width: isExpanded ? Insets.infinity : null,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: _ButtonType(
              text: text,
              buttonType: buttonType,
              icon: icon,
              isEnabled: isEnabled,
              isExpanded: isExpanded,
              onPressed: onPressed,
              buttonStyle: buttonStyle,
              iconPadding: iconPadding,
              contentPadding: contentPadding,
              textStyle: textStyle,
            ),
          ),
        ),
      );
}

class _ButtonType extends StatelessWidget {
  const _ButtonType({
    required this.text,
    required this.buttonType,
    required this.icon,
    this.isEnabled = true,
    this.isExpanded = false,
    this.onPressed,
    this.buttonStyle,
    this.iconPadding,
    this.contentPadding,
    this.textStyle,
  });

  final bool isEnabled;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final EdgeInsets? iconPadding;
  final EdgeInsets? contentPadding;
  final String text;
  final TextStyle? textStyle;
  final bool isExpanded;
  final ButtonType buttonType;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final Padding iconWithPadding = Padding(
      padding: iconPadding ??
          const EdgeInsets.fromLTRB(
            Insets.xxSmall,
            Insets.medium,
            Insets.zero,
            Insets.medium,
          ),
      child: icon,
    );
    final Color primaryColor = context.colorScheme.primary;
    final Color secondaryColor = context.colorScheme.secondary;
    final Color onPrimaryColor = context.colorScheme.onPrimary;

    return switch (buttonType) {
      ButtonType.elevated when icon != null => ElevatedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          icon: iconWithPadding,
          label: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: primaryColor,
          ),
        ),
      ButtonType.elevated => ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: primaryColor,
          ),
        ),
      ButtonType.filled when icon != null => FilledButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          icon: iconWithPadding,
          label: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            hasIcon: true,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: onPrimaryColor,
          ),
        ),
      ButtonType.filled => FilledButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: onPrimaryColor,
          ),
        ),
      ButtonType.tonal when icon != null => FilledButton.tonalIcon(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          icon: iconWithPadding,
          label: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            hasIcon: true,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: secondaryColor,
          ),
        ),
      ButtonType.tonal => FilledButton.tonal(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: secondaryColor,
          ),
        ),
      ButtonType.outlined when icon != null => OutlinedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          icon: iconWithPadding,
          label: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            hasIcon: true,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: primaryColor,
          ),
        ),
      ButtonType.outlined => OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: primaryColor,
          ),
        ),
      ButtonType.text when icon != null => TextButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          icon: iconWithPadding,
          label: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            hasIcon: true,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: primaryColor,
          ),
        ),
      ButtonType.text => TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: primaryColor,
          ),
        ),
    };
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.isEnabled,
    required this.text,
    required this.defaultTextColor,
    this.hasIcon = false,
    this.textStyle,
    this.isExpanded = false,
    this.contentPadding,
  });

  final EdgeInsets? contentPadding;
  final bool isEnabled;
  final String text;
  final TextStyle? textStyle;
  final Color defaultTextColor;
  final bool hasIcon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets defaultPadding = hasIcon
        ? EdgeInsets.fromLTRB(
            Insets.zero,
            Insets.medium,
            isExpanded ? Insets.medium * 2 : Insets.medium,
            Insets.medium,
          )
        : Paddings.allMedium;
    final TextStyle defaultTextStyle =
        context.textTheme.bodyLarge!.copyWith(color: defaultTextColor);
    return SizedBox(
      width: isExpanded ? Insets.infinity : null,
      child: Padding(
        padding: contentPadding ?? defaultPadding,
        child: isEnabled
            ? VeryGoodCoreText(
                text: text,
                style: textStyle ?? defaultTextStyle,
                textAlign: TextAlign.center,
              )
            : Center(
                child: SizedBox.square(
                  dimension: textStyle?.fontSize ?? defaultTextStyle.fontSize,
                  child: const CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
