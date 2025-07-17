import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';
import 'package:very_good_core/features/home/presentation/widgets/post_container.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_localization.dart';
import '../../../utils/test_utils.dart';

void main() {
  late MockAppLocalizationBloc appLocalizationBloc;

  setUp(() {
    appLocalizationBloc = MockAppLocalizationBloc();

    when(appLocalizationBloc.state).thenAnswer((_) => AppLocale.values.first.buildSync());
  });

  tearDown(() {
    appLocalizationBloc.close();
  });

  group(PostContainer, () {
    goldenTest(
      'renders correctly',
      fileName: 'post_container'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: () => MockLocalization(
              appLocalizationBloc: appLocalizationBloc,
              child: Column(
                children: <Widget>[
                  PostContainer(post: mockPost),
                  const Spacer(),
                ],
              ),
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'default',
            builder: () => MockLocalization(
              appLocalizationBloc: appLocalizationBloc,
              child: Column(
                children: <Widget>[
                  PostContainer(
                    post: mockPost.copyWith(
                      urlOverriddenByDest: Url('https://www.google.com/'),
                      selftext: ValueString('post', fieldName: 'selfText'),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}
