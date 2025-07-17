import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_sizes.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

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
      padding: const EdgeInsets.symmetric(vertical: AppSizes.small, horizontal: AppSizes.medium),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: AppTheme.defaultBorderRadius,
      ),
      width: isExpanded ? AppSizes.infinity : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          VeryGoodCoreText(
            text: title,
            style: context.textTheme.bodySmall?.copyWith(color: titleColor ?? context.colorScheme.primary),
          ),
          Gap.xxSmall(),
          VeryGoodCoreText(
            text: description,
            style: context.textTheme.titleMedium?.copyWith(color: descriptionColor),
          ),
        ],
      ),
    ),
  );
}
