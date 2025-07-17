import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/text_field_type.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}TextField extends HookWidget {
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
    this.isDisabled = false,
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
  final {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon? prefix;
  final bool isDisabled;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Color? borderColor;

  InputDecoration? _getInputDecoration(BuildContext context, TextStyle? textStyle, {required bool isFocused}) {
    final Color? prefixColor = isFocused ? context.colorScheme.primary : null;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefix?.copyWith(copyColor: prefixColor),
      suffixIcon: suffix,
      fillColor: isDisabled ? context.colorScheme.surfaceContainerHigh : fillColor,
      filled: true,
    ).applyDefaults(context.theme.inputDecorationTheme);
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode effectiveFocusNode = focusNode ?? useFocusNode();
    final bool isFocused = useListenable(effectiveFocusNode).hasFocus;
    final GlobalKey<FormFieldState<String>> formFieldKey = useMemoized(GlobalKey<FormFieldState<String>>.new);

    useEffect(() {
      void listener() {
        if (effectiveFocusNode.hasFocus && (formFieldKey.currentState?.hasError ?? false)) {
          formFieldKey.currentState?.reset();
        }
      }

      effectiveFocusNode.addListener(listener);
      return () => effectiveFocusNode.removeListener(listener);
    }, <Object?>[effectiveFocusNode]);

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
            focusNode: effectiveFocusNode,
            hintText: hintText,
            labelText: labelText,
            inputDecoration: _getInputDecoration(context, style, isFocused: isFocused),
          ),
          TextFieldType.form => TextFormField(
            key: formFieldKey,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUnfocus,
            inputFormatters: inputFormatters,
            readOnly: readOnly || isDisabled,
            canRequestFocus: !(readOnly || isDisabled),
            controller: controller,
            focusNode: effectiveFocusNode,
            decoration: decoration ?? _getInputDecoration(context, style, isFocused: isFocused),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style: style,
            textAlign: textAlign,
            autofocus: autofocus,
            maxLength: maxLength,
            onChanged: onChanged,
            buildCounter: (_, {int? currentLength, int? maxLength, bool? isFocused}) => null,
          ),
          TextFieldType.normal => TextField(
            key: formFieldKey,
            readOnly: readOnly || isDisabled,
            controller: controller,
            focusNode: effectiveFocusNode,
            decoration: decoration ?? _getInputDecoration(context, style, isFocused: isFocused),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            canRequestFocus: !(readOnly || isDisabled),
            style: style,
            textAlign: textAlign,
            autofocus: autofocus,
            maxLength: maxLength,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            buildCounter: (_, {int? currentLength, int? maxLength, bool? isFocused}) => null,
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
                    icon: right(isPasswordHidden.value ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              textInputAction: textInputAction,
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
