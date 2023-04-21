import 'package:flutter/material.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/themes/spacing.dart';

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
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: Insets.medium),
            child: icon != null
                ? _ButtonTypeWithIcon(
                    text: text,
                    buttonType: buttonType,
                    icon: icon!,
                    isEnabled: isEnabled,
                    isExpanded: isExpanded,
                    onPressed: onPressed,
                    buttonStyle: buttonStyle,
                    iconPadding: iconPadding,
                    contentPadding: contentPadding,
                    textStyle: textStyle,
                  )
                : _ButtonType(
                    isEnabled: isEnabled,
                    isExpanded: isExpanded,
                    onPressed: onPressed,
                    buttonStyle: buttonStyle,
                    contentPadding: contentPadding,
                    text: text,
                    textStyle: textStyle,
                    buttonType: buttonType,
                  ),
          ),
        ),
      );
}

class _ButtonTypeWithIcon extends StatelessWidget {
  const _ButtonTypeWithIcon({
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
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final Padding iconWithPadding = Padding(
      padding: iconPadding ??
          const EdgeInsets.fromLTRB(
            Insets.xxsmall,
            Insets.medium,
            Insets.zero,
            Insets.medium,
          ),
      child: icon,
    );

    switch (buttonType) {
      case ButtonType.elevated:
        return ElevatedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          icon: iconWithPadding,
          label: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: context.colorScheme.primary,
          ),
        );
      case ButtonType.filled:
        return FilledButton.icon(
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
            defaultTextColor: context.colorScheme.onPrimary,
          ),
        );
      case ButtonType.tonal:
        return FilledButton.tonalIcon(
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
            defaultTextColor: context.colorScheme.secondary,
          ),
        );
      case ButtonType.outlined:
        return OutlinedButton.icon(
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
            defaultTextColor: context.colorScheme.primary,
          ),
        );
      case ButtonType.text:
        return TextButton.icon(
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
            defaultTextColor: context.colorScheme.primary,
          ),
        );
    }
  }
}

class _ButtonType extends StatelessWidget {
  const _ButtonType({
    required this.text,
    required this.buttonType,
    this.isEnabled = true,
    this.isExpanded = false,
    this.onPressed,
    this.buttonStyle,
    this.contentPadding,
    this.textStyle,
  });

  final bool isEnabled;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final EdgeInsets? contentPadding;
  final String text;
  final TextStyle? textStyle;
  final bool isExpanded;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: context.colorScheme.primary,
          ),
        );
      case ButtonType.filled:
        return FilledButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: context.colorScheme.onPrimary,
          ),
        );
      case ButtonType.tonal:
        return FilledButton.tonal(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: context.colorScheme.secondary,
          ),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: context.colorScheme.primary,
          ),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: _ButtonContent(
            contentPadding: contentPadding,
            isEnabled: isEnabled,
            text: text,
            textStyle: textStyle,
            isExpanded: isExpanded,
            defaultTextColor: context.colorScheme.primary,
          ),
        );
    }
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
        : const EdgeInsets.all(Insets.medium);
    final TextStyle defaultTextStyle =
        context.textTheme.bodyLarge!.copyWith(color: defaultTextColor);
    return SizedBox(
      width: isExpanded ? Insets.infinity : null,
      child: Padding(
        padding: contentPadding ?? defaultPadding,
        child: isEnabled
            ? Text(
                text,
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
