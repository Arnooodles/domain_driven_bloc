import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar({
    required this.size,
    this.imageUrl,
    this.padding,
    super.key,
  });

  final String? imageUrl;
  final double size;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => Semantics(
        image: true,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  memCacheWidth: size.toInt(),
                  memCacheHeight: size.toInt(),
                  imageBuilder: (
                    BuildContext context,
                    ImageProvider<Object> imageProvider,
                  ) =>
                      Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                    width: size,
                    height: size,
                  ),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(
                    icon: right(Icons.account_circle),
                    size: size,
                  ),
                  fit: BoxFit.cover,
                )
              : {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.account_circle), size: size),
        ),
      );
}
