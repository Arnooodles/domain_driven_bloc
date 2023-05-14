import 'package:flutter/material.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/core/presentation/widgets/app_title.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.background,
        body: const SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Center(
                    child: AppTitle(),
                  ),
                ),
                Flexible(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      );
}
