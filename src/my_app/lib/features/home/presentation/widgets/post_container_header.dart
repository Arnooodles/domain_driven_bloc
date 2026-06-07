import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_text_style.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

class PostContainerHeader extends StatelessWidget {
  const PostContainerHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: Paddings.allSmall,
    child: VeryGoodCoreText(
      text: title,
      style: context.textTheme.titleMedium?.copyWith(fontWeight: AppFontWeight.semiBold),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    ),
  );
}
