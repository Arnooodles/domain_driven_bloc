// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_sizes.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar({
    required this.size,
    this.imageUrl,
    this.padding,

    this.borderSize = AppSizes.xxSmall,
    this.isCachedSize = true,
    this.isLoading = false,
    this.borderColor,
    this.cacheManager,
    this.maxSize,
    super.key,
  });

  final String? imageUrl;
  final double size;
  final int? maxSize;
  final EdgeInsets? padding;
  final Color? borderColor;

  final double borderSize;
  final bool isCachedSize;
  final bool isLoading;
  final BaseCacheManager? cacheManager;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    child: Padding(
      padding: padding ?? EdgeInsets.zero,
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              memCacheWidth: isCachedSize ? size.toInt() : null,
              memCacheHeight: isCachedSize ? size.toInt() : null,
              maxWidthDiskCache: maxSize,
              maxHeightDiskCache: maxSize,
              fadeOutDuration: Duration.zero,
              fadeInDuration: Duration.zero,
              placeholderFadeInDuration: Duration.zero,
              cacheManager: cacheManager,
              imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: borderSize, color: borderColor ?? context.colorScheme.surface),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
                width: size,
                height: size,
              ),
              errorWidget: (_, _, _) => _DefaultIcon(size: size),
              placeholder: (_, _) => Skeletonizer(
                enabled: isLoading,
                child: _DefaultIcon(size: size),
              ),
              fit: BoxFit.cover,
            )
          : _DefaultIcon(size: size),
    ),
  );
}

class _DefaultIcon extends StatelessWidget {
  const _DefaultIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Skeleton.replace(
    replacement: Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      child: const ClipOval(child: ColoredBox(color: Colors.black)),
    ),
    child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.account_circle), size: size),
  );
}
