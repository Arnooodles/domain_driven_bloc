import 'package:flutter/material.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/themes/text_styles.dart';
import 'package:very_good_core/app/utils/extensions.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) => Text(
        Constant.appName,
        style: AppTextStyle.displayLarge
            .copyWith(color: context.colorScheme.primary),
      );
}
