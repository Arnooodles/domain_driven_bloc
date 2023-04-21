import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/app_title.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.background,
        body: SafeArea(
          child: Center(
            child: Column(
              children: const <Widget>[
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
