// ignore_for_file: avoid-returning-widgets, prefer-correct-edge-insets-constructor

import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_sizes.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/core/domain/entity/enum/button_type.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

class VeryGoodCoreButton extends StatelessWidget {
  const VeryGoodCoreButton({
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.isExpanded = false,
    this.buttonType = ButtonType.filled,
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
  final bool isLoading;
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
      width: isExpanded ? AppSizes.infinity : null,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: _ButtonType(
          text: text,
          buttonType: buttonType,
          icon: icon,
          isEnabled: isEnabled,
          isExpanded: isExpanded,
          isLoading: isLoading,
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
    this.isLoading = false,
    this.isEnabled = true,
    this.isExpanded = false,
    this.onPressed,
    this.buttonStyle,
    this.iconPadding,
    this.contentPadding,
    this.textStyle,
  });

  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final EdgeInsets? iconPadding;
  final EdgeInsets? contentPadding;
  final String text;
  final TextStyle? textStyle;
  final bool isExpanded;
  final ButtonType buttonType;
  final Widget? icon;

  Widget _buildContent(BuildContext context, {bool hasIcon = false, bool isTonal = false}) => _ButtonContent(
    contentPadding: contentPadding,
    isLoading: isLoading,
    text: text,
    hasIcon: hasIcon,
    textStyle: isTonal ? textStyle?.copyWith(color: context.colorScheme.onSecondaryContainer) : textStyle,
    isExpanded: isExpanded,
  );

  Widget? _buildIcon() {
    if (icon == null) return null;

    return Padding(
      padding:
          iconPadding ?? const EdgeInsets.fromLTRB(AppSizes.medium, AppSizes.medium, AppSizes.zero, AppSizes.medium),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget? iconWidget = _buildIcon();
    final VoidCallback? callback = (isEnabled && !isLoading) ? onPressed : null;

    switch (buttonType) {
      case ButtonType.elevated:
        return iconWidget != null
            ? ElevatedButton.icon(
                onPressed: callback,
                style: buttonStyle,
                icon: iconWidget,
                label: _buildContent(context, hasIcon: true),
              )
            : ElevatedButton(onPressed: callback, style: buttonStyle, child: _buildContent(context));
      case ButtonType.filled:
        return iconWidget != null
            ? FilledButton.icon(
                onPressed: callback,
                style: buttonStyle,
                icon: iconWidget,
                label: _buildContent(context, hasIcon: true),
              )
            : FilledButton(onPressed: callback, style: buttonStyle, child: _buildContent(context));
      case ButtonType.tonal:
        final ButtonStyle tonalStyle = FilledButton.styleFrom(
          backgroundColor: context.colorScheme.secondaryContainer,
          foregroundColor: context.colorScheme.onSecondaryContainer,
        ).merge(buttonStyle);

        return iconWidget != null
            ? FilledButton.icon(
                onPressed: callback,
                style: tonalStyle,
                icon: iconWidget,
                label: _buildContent(context, hasIcon: true, isTonal: true),
              )
            : FilledButton(onPressed: callback, style: tonalStyle, child: _buildContent(context, isTonal: true));
      case ButtonType.outlined:
        return iconWidget != null
            ? OutlinedButton.icon(
                onPressed: callback,
                style: buttonStyle,
                icon: iconWidget,
                label: _buildContent(context, hasIcon: true),
              )
            : OutlinedButton(onPressed: callback, style: buttonStyle, child: _buildContent(context));
      case ButtonType.text:
        return iconWidget != null
            ? TextButton.icon(
                onPressed: callback,
                style: buttonStyle,
                icon: iconWidget,
                label: _buildContent(context, hasIcon: true),
              )
            : TextButton(onPressed: callback, style: buttonStyle, child: _buildContent(context));
    }
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.isLoading,
    required this.text,

    this.hasIcon = false,
    this.textStyle,
    this.isExpanded = false,
    this.contentPadding,
  });

  final EdgeInsets? contentPadding;
  final bool isLoading;
  final String text;
  final TextStyle? textStyle;

  final bool hasIcon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets defaultPadding = hasIcon
        ? EdgeInsets.fromLTRB(
            AppSizes.zero,
            AppSizes.medium,
            isExpanded ? AppSizes.medium * 2 : AppSizes.medium,
            AppSizes.medium,
          )
        : Paddings.allMedium;

    return SizedBox(
      width: isExpanded ? AppSizes.infinity : null,
      child: Padding(
        padding: contentPadding ?? defaultPadding,
        child: !isLoading
            ? VeryGoodCoreText(text: text, style: textStyle, textAlign: TextAlign.center)
            : Center(
                child: SizedBox.square(
                  dimension: textStyle?.fontSize ?? DefaultTextStyle.of(context).style.fontSize,
                  child: const CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
