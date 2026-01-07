// ignore_for_file: avoid-returning-widgets, prefer-correct-edge-insets-constructor

import 'package:flutter/material.dart';
import 'package:flutter_event_limiter/flutter_event_limiter.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/button_type.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';

typedef Throttler = void Function()? Function(void Function()?);

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Button extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Button({
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

  Widget _buildButton({
    required BuildContext context,
    required VoidCallback? callback,
    required Widget? icon,
    required Widget child,
  }) => ThrottledBuilder(
    builder: (BuildContext context, Throttler throttle) {
      final VoidCallback? throttledCallback = throttle(callback);
      return switch (buttonType) {
        ButtonType.elevated =>
          icon != null
              ? ElevatedButton.icon(onPressed: throttledCallback, style: buttonStyle, icon: icon, label: child)
              : ElevatedButton(onPressed: throttledCallback, style: buttonStyle, child: child),
        ButtonType.filled =>
          icon != null
              ? FilledButton.icon(onPressed: throttledCallback, style: buttonStyle, icon: icon, label: child)
              : FilledButton(onPressed: throttledCallback, style: buttonStyle, child: child),
        ButtonType.tonal =>
          icon != null
              ? FilledButton.icon(
                  onPressed: throttledCallback,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.secondaryContainer,
                    foregroundColor: context.colorScheme.onSecondaryContainer,
                  ).merge(buttonStyle),
                  icon: icon,
                  label: child,
                )
              : FilledButton(
                  onPressed: throttledCallback,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.secondaryContainer,
                    foregroundColor: context.colorScheme.onSecondaryContainer,
                  ).merge(buttonStyle),
                  child: child,
                ),
        ButtonType.outlined =>
          icon != null
              ? OutlinedButton.icon(onPressed: throttledCallback, style: buttonStyle, icon: icon, label: child)
              : OutlinedButton(onPressed: throttledCallback, style: buttonStyle, child: child),
        ButtonType.text =>
          icon != null
              ? TextButton.icon(onPressed: throttledCallback, style: buttonStyle, icon: icon, label: child)
              : TextButton(onPressed: throttledCallback, style: buttonStyle, child: child),
      };
    },
  );

  @override
  Widget build(BuildContext context) {
    final Widget? iconWidget = _buildIcon();
    final VoidCallback? callback = (isEnabled && !isLoading) ? onPressed : null;
    final bool isTonal = buttonType == ButtonType.tonal;
    final Widget child = _buildContent(context, hasIcon: iconWidget != null, isTonal: isTonal);
    final Widget button = _buildButton(context: context, callback: callback, icon: iconWidget, child: child);

    return Semantics(
      enabled: isEnabled,
      button: true,
      label: text,
      child: SizedBox(
        width: isExpanded ? AppSizes.infinity : null,
        child: Padding(padding: padding ?? EdgeInsets.zero, child: button),
      ),
    );
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
            ? {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(text: text, style: textStyle, textAlign: TextAlign.center)
            : Center(
                child: SizedBox.square(
                  dimension: textStyle?.fontSize ?? context.defaultTextStyle.style.fontSize,
                  child: const CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
