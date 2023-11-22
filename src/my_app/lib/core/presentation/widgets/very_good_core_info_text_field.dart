import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';

class VeryGoodCoreInfoTextField extends StatelessWidget {
  const VeryGoodCoreInfoTextField({
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
              Gap.xxsmall(),
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
