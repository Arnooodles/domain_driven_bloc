import 'package:flutter/material.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/app/themes/text_styles.dart';
import 'package:very_good_core/app/utils/extensions.dart';
import 'package:very_good_core/app/utils/shimmer.dart';

class ProfileLoading extends StatelessWidget {
  const ProfileLoading({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.xl),
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
                    padding: EdgeInsets.all(Insets.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer(
                          width: context.screenWidth * 0.5,
                          height: AppTextStyle.headlineMedium.fontSize ?? 28,
                        ),
                        VSpace.xs,
                        Shimmer(
                          width: context.screenWidth * 0.4,
                          height: AppTextStyle.headlineMedium.fontSize ?? 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            VSpace.med,
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final int delay = (index + 1) * 300;

                  return Shimmer(
                    millisecondsDelay: delay,
                    width: context.screenWidth * 0.4,
                    height: 70,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    VSpace(Insets.sm),
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
            VSpace(Insets.lg),
          ],
        ),
      );
}
