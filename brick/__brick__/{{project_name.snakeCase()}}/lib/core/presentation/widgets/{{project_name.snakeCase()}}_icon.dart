import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon({
    required this.icon,
    super.key,
    this.size,
    this.color,
    this.alignment = Alignment.center,
    this.child,
  });

  final Either<String, IconData> icon;
  final double? size;
  final Color? color;
  final Alignment alignment;
  final Widget? child;

  {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon copyWith({Color? copyColor}) =>
      {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: icon, color: copyColor, size: size, alignment: alignment, child: child);

  @override
  Widget build(BuildContext context) => child != null
      ? Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _Icon(icon: icon, size: size, alignment: alignment, color: color),
            Gap.large(),
            child!,
          ],
        )
      : _Icon(icon: icon, size: size, alignment: alignment, color: color);
}

class _Icon extends StatelessWidget {
  const _Icon({required this.icon, required this.size, required this.alignment, required this.color});

  final Either<String, IconData> icon;
  final double? size;
  final Alignment alignment;
  final Color? color;

  @override
  Widget build(BuildContext context) => icon.fold(
    (String path) => SvgPicture.asset(
      path,
      height: size,
      width: size,
      alignment: alignment,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    ),
    (IconData iconData) => Icon(iconData, color: color, size: size ?? AppSizes.large),
  );
}
