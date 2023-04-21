import 'package:flutter/material.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/helpers/extensions.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) => Text(
        Constant.appName,
        textAlign: TextAlign.center,
        style: context.textTheme.displayLarge
            ?.copyWith(color: context.colorScheme.primary),
      );
}
