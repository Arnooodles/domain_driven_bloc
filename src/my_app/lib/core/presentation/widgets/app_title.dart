import 'package:flutter/material.dart';
import 'package:my_app/app/constants/constant.dart';
import 'package:my_app/app/themes/text_styles.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) => Text(
        Constant.appName,
        style: AppTextStyle.headline1
            .copyWith(color: Theme.of(context).colorScheme.primary),
      );
}
