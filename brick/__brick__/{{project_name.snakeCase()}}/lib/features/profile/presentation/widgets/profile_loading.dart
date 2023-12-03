import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/shimmer.dart';

class ProfileLoading extends StatelessWidget {
  const ProfileLoading({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xlarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Shimmer.round(
                  size: 80,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Insets.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer(
                          width: context.screenWidth * 0.5,
                          height:
                              context.textTheme.headlineMedium?.fontSize ?? 28,
                        ),
                        Gap.xsmall(),
                        Shimmer(
                          width: context.screenWidth * 0.4,
                          height:
                              context.textTheme.headlineMedium?.fontSize ?? 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap.medium(),
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final int delay = (index + 1) * 300;

                  return Shimmer(
                    millisecondsDelay: delay,
                    width: context.screenWidth * 0.4,
                    height: 70,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Gap(Insets.small),
                itemCount: 5,
              ),
            ),
            Center(
              child: Shimmer(
                millisecondsDelay: 1800,
                radius: AppTheme.defaultRadius * 2,
                width: context.screenWidth,
                height: 50,
              ),
            ),
            const Gap(Insets.large),
          ],
        ),
      );
}
