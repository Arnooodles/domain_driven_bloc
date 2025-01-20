import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/text_field_type.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}TextField extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}TextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.textInputAction,
    this.keyboardType,
    this.onChanged,
    this.padding,
    this.textFieldType = TextFieldType.normal,
    this.maxLength,
    this.autofocus = false,
    this.onSubmitted,
    this.focusNode,
    this.suffix,
    this.textAlign = TextAlign.left,
    this.contentPadding,
    this.style,
    this.hintTextStyle,
    this.decoration,
    super.key,
    this.readOnly = false,
    this.prefix,
    this.disabled = false,
    this.validator,
    this.inputFormatters,
    this.floatingLabelBehavior,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextFieldType textFieldType;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final EdgeInsets? padding;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final Widget? suffix;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final TextStyle? hintTextStyle;
  final InputDecoration? decoration;
  final String? labelText;
  final bool readOnly;
  final Widget? prefix;
  final bool disabled;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Color? borderColor;

  OutlineInputBorder _getBorder(Color color) => OutlineInputBorder(
        borderRadius: borderRadius ?? AppTheme.defaultBoardRadius / 2,
        borderSide: BorderSide(
          color: color,
        ),
      );

  InputDecoration _getInputDecoration(
    BuildContext context,
    TextStyle? defaultTextStyle,
  ) =>
      InputDecoration(
        floatingLabelBehavior: floatingLabelBehavior,
        labelText: disabled ? null : labelText,
        hintText: hintText,
        hintStyle: hintTextStyle ?? defaultTextStyle,
        contentPadding: contentPadding,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: fillColor != null || disabled,
        fillColor: disabled ? context.colorScheme.outlineVariant : fillColor,
        focusedBorder: _getBorder(
          disabled
              ? context.colorScheme.outlineVariant
              : borderColor ?? context.colorScheme.primary,
        ),
        focusedErrorBorder: _getBorder(context.colorScheme.error),
        errorBorder: _getBorder(context.colorScheme.error),
        enabledBorder: _getBorder(
          disabled
              ? context.colorScheme.outlineVariant
              : borderColor ?? context.colorScheme.onSurface,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextStyle? defaultTextStyle = context.textTheme.bodyLarge?.copyWith(
      color: disabled ? colorScheme.outline : colorScheme.onSurface,
    );

    return Semantics(
      key: Key(labelText ?? 'text_field'),
      textField: true,
      label: labelText,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: switch (textFieldType) {
          TextFieldType.password => _PasswordTextField(
              controller: controller,
              onChanged: onChanged,
              autofocus: autofocus,
              onSubmitted: onSubmitted,
              textInputAction: textInputAction,
              focusNode: focusNode,
              hintText: hintText,
              labelText: labelText,
              inputDecoration: _getInputDecoration(context, defaultTextStyle),
            ),
          TextFieldType.form => TextFormField(
              key: ValueKey<String>(labelText ?? 'text_field'),
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: inputFormatters,
              readOnly: readOnly || disabled,
              controller: controller,
              focusNode: focusNode,
              decoration:
                  decoration ?? _getInputDecoration(context, defaultTextStyle),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style ?? defaultTextStyle,
              textAlign: textAlign,
              autofocus: autofocus,
              maxLength: maxLength,
              onChanged: onChanged,
              buildCounter: (
                _, {
                int? currentLength,
                int? maxLength,
                bool? isFocused,
              }) =>
                  null,
            ),
          TextFieldType.normal => TextField(
              readOnly: readOnly || disabled,
              controller: controller,
              focusNode: focusNode,
              decoration:
                  decoration ?? _getInputDecoration(context, defaultTextStyle),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style ?? defaultTextStyle,
              textAlign: textAlign,
              autofocus: autofocus,
              maxLength: maxLength,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              buildCounter: (
                _, {
                int? currentLength,
                int? maxLength,
                bool? isFocused,
              }) =>
                  null,
            ),
        },
      ),
    );
  }
}

class _PasswordTextField extends HookWidget {
  const _PasswordTextField({
    required this.hintText,
    this.labelText,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
    this.inputDecoration,
  });

  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final String? labelText;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isPasswordHidden = useState<bool>(true);
    final ColorScheme colorScheme = context.colorScheme;
    final TextStyle? textStyle =
        context.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface);

    return Row(
      children: <Widget>[
        Expanded(
          child: Semantics(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: isPasswordHidden.value,
              decoration: inputDecoration?.copyWith(
                suffixIcon: GestureDetector(
                  key: const Key('password_icon'),
                  onTap: () => isPasswordHidden.value = !isPasswordHidden.value,
                  child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(
                    icon: right(
                      isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              textInputAction: textInputAction,
              style: textStyle,
              textAlign: TextAlign.left,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
        ),
      ],
    );
  }
}
