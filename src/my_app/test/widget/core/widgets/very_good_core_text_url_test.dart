import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text_url.dart';

import '../../../utils/test_utils.dart';

void main() {
  group(VeryGoodCoreTextUrl, () {
    int count = 0;
    const String url = 'https://www.example.com';
    goldenTest(
      'renders correctly',
      fileName: 'very_good_core_text_url'.goldensVersion,
      constraints: const BoxConstraints(minWidth: 200),
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: SizedBox(
              height: 20,
              child: VeryGoodCoreTextUrl(
                url: Url(url),
                onTap: () => count++,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'no icon',
            child: SizedBox(
              height: 20,
              child: VeryGoodCoreTextUrl(
                url: Url(url),
                onTap: () => count++,
                isShowIcon: false,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
