import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/app/generated/assets.gen.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_avatar.dart';

import '../../utils/mock_cache_manager.dart';
import '../../utils/test_utils.dart';

void main() {
  group(VeryGoodCoreAvatar, () {
    goldenTest(
      'renders correctly',
      fileName: 'very_good_core_avatar'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        //TODO: precacheImages causes infinite loading, wait for updates if there are any fix (https://github.com/Baseflow/flutter_cached_network_image/issues/307#issuecomment-2697335138)
        // await precacheImages(tester);
        await tester.pump(const Duration(seconds: 1));
      },

      pumpWidget: (WidgetTester tester, Widget testWidget) async {
        await tester.pumpWidget(testWidget);
        await tester.runAsync(() async {
          await tester.pump();
        });
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(name: 'without image url', child: const VeryGoodCoreAvatar(size: 50)),
          GoldenTestScenario(
            name: 'with image url',
            child: VeryGoodCoreAvatar(
              size: 50,
              cacheManager: MockCacheManager(),
              imageUrl: Assets.icons.splashIcon.path,
            ),
          ),
          GoldenTestScenario(
            name: 'isLoading',
            child: VeryGoodCoreAvatar(
              size: 50,
              isLoading: true,
              imageUrl: Assets.icons.splashIcon.path,
              cacheManager: MockCacheManager(),
              padding: const EdgeInsets.all(10),
            ),
          ),
          GoldenTestScenario(
            name: 'with error image',
            child: VeryGoodCoreAvatar(
              size: 50,
              cacheManager: InvalidCacheManager(),
              imageUrl: Assets.icons.launcherIcon.path,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  });
}
