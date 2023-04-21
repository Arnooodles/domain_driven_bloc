import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField({
    required this.title,
    required this.description,
    this.isExpanded = true,
    this.titleColor,
    this.descriptionColor,
    super.key,
  });

  final String title;
  final String description;
  final bool isExpanded;
  final Color? titleColor;
  final Color? descriptionColor;

  @override
  Widget build(BuildContext context) => Semantics(
        textField: true,
        readOnly: true,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.small,
            horizontal: Insets.medium,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: AppTheme.defaultBoardRadius,
          ),
          width: isExpanded ? Insets.infinity : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: context.textTheme.bodySmall?.copyWith(
                  color: titleColor ?? context.colorScheme.secondary,
                ),
              ),
              VSpace.xxsmall(),
              Text(
                description,
                style: context.textTheme.titleMedium?.copyWith(
                  color: descriptionColor ??
                      context.colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      );
}
