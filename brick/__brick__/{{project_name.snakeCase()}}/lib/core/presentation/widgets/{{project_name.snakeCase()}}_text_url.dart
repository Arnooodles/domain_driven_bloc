import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/value_object.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}TextUrl extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}TextUrl({
    required this.url,
    required this.onTap,
    this.style,
    this.isShowIcon = true,
    super.key,
  });

  final Url url;
  final TextStyle? style;
  final bool isShowIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                url.getOrCrash(),
                style: style?.copyWith(decoration: TextDecoration.underline) ??
                    context.textTheme.bodySmall?.copyWith(
                      color: AppColors.defaultTextUrl,
                      decoration: TextDecoration.underline,
                    ),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),
            if (isShowIcon)
              Padding(
                padding: const EdgeInsets.only(left: Insets.xxsmall),
                child: Icon(
                  Icons.open_in_new,
                  size:
                      style?.fontSize ?? context.textTheme.bodySmall?.fontSize,
                  color: AppColors.defaultTextUrl,
                ),
              ),
          ],
        ),
      );
}
