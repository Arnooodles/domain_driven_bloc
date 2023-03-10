import 'package:flutter/material.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/app/themes/text_styles.dart';
import 'package:very_good_core/app/utils/extensions.dart';

class VeryGoodCoreInfoTextField extends StatelessWidget {
  const VeryGoodCoreInfoTextField({
    super.key,
    required this.title,
    required this.description,
    this.isExpanded = true,
    this.titleColor,
    this.descriptionColor,
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
          padding:
              EdgeInsets.symmetric(vertical: Insets.sm, horizontal: Insets.med),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: AppTheme.defaultBoardRadius,
          ),
          width: isExpanded ? double.infinity : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: AppTextStyle.bodySmall.copyWith(
                  color: titleColor ?? context.colorScheme.secondary,
                ),
              ),
              VSpace.xxs,
              Text(
                description,
                style: AppTextStyle.titleMedium.copyWith(
                  color: descriptionColor ??
                      context.colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      );
}
