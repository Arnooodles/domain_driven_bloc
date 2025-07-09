import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/app/themes/app_colors.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';
import 'package:very_good_core/features/home/presentation/widgets/post_container_header.dart';

import '../../../utils/generated_mocks.mocks.dart';
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
  group(PostContainerHeader, () {
    goldenTest(
      'renders correctly',
      fileName: 'post_container_header'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: MockLocalization(
              appLocalizationBloc: appLocalizationBloc,
              child: PostContainerHeader(post: mockPost),
            ),
          ),
          GoldenTestScenario(
            name: 'default with transparent link flair',
            child: MockLocalization(
              appLocalizationBloc: appLocalizationBloc,
              child: PostContainerHeader(post: mockPost.copyWith(linkFlairBackgroundColor: AppColors.transparent)),
            ),
          ),
          GoldenTestScenario(
            name: 'without tag',
            child: MockLocalization(
              appLocalizationBloc: appLocalizationBloc,
              child: PostContainerHeader(
                post: mockPost.copyWith(linkFlairText: ValueString('linkFlairText', fieldName: 'linkFlairText')),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
