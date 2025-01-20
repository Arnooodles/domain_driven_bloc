import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon({
    required this.icon,
    super.key,
    this.size,
    this.color,
    this.alignment = Alignment.center,
  });

  final Either<String, IconData> icon;
  final double? size;
  final Color? color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => icon.fold(
        (String path) => SvgPicture.asset(
          path,
          height: size,
          width: size,
          alignment: alignment,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        ),
        (IconData iconData) => Icon(
          iconData,
          color: color,
          size: size ?? AppSizes.size24,
        ),
      );
}
