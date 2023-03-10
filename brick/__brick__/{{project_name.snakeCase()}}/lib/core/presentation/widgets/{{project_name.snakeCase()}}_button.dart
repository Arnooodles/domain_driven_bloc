import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/text_styles.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Button extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Button({
    super.key,
    required this.text,
    this.isEnabled = true,
    this.isExpanded = false,
    this.buttonType = ButtonType.elevated,
    required this.onPressed,
    this.buttonStyle,
    this.textStyle,
    this.padding,
    this.contentPadding,
    this.icon,
    this.iconPadding,
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
          width: isExpanded ? double.infinity : null,
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: Insets.med),
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
          EdgeInsets.fromLTRB(
            Insets.xs,
            Insets.med,
            0,
            Insets.med,
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
          ),
        );
    }
  }
}

class _ButtonType extends StatelessWidget {
  const _ButtonType({
    this.isEnabled = true,
    this.isExpanded = false,
    this.onPressed,
    this.buttonStyle,
    this.contentPadding,
    required this.text,
    this.textStyle,
    required this.buttonType,
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
          ),
        );
    }
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    this.contentPadding,
    required this.isEnabled,
    required this.text,
    this.hasIcon = false,
    this.textStyle,
    this.isExpanded = false,
  });

  final EdgeInsets? contentPadding;
  final bool isEnabled;
  final String text;
  final TextStyle? textStyle;
  final bool hasIcon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets defaultPadding = hasIcon
        ? EdgeInsets.fromLTRB(
            0,
            Insets.med,
            Insets.med,
            Insets.med,
          )
        : EdgeInsets.all(Insets.med);

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      child: Padding(
        padding: contentPadding ?? defaultPadding,
        child: isEnabled
            ? Text(
                text,
                style: textStyle ?? AppTextStyle.bodyLarge,
                textAlign: TextAlign.center,
              )
            : Center(
                child: SizedBox.square(
                  dimension:
                      textStyle?.fontSize ?? AppTextStyle.bodyLarge.fontSize,
                  child: const CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
