import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_sizes.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

class EmptyPost extends StatelessWidget {
  const EmptyPost({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: <Widget>[
      SliverFillRemaining(
        child: Container(
          padding: Paddings.horizontalLarge,
          width: AppSizes.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                VeryGoodCoreIcon(icon: right(Icons.list_alt), size: 200),
                Padding(
                  padding: const EdgeInsets.only(top: AppSizes.small, bottom: AppSizes.xSmall),
                  child: VeryGoodCoreText(
                    text: context.i18n.post.label.empty_post,
                    style: context.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
