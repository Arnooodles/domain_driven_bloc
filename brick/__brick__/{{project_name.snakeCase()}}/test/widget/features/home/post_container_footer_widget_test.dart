// ignore_for_file: discarded_futures

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_footer.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/mock_localization.dart';
import '../../../utils/test_utils.dart';

void main() {
  late MockAppLocalizationCubit appLocalizationCubit;

  setUp(() {
    appLocalizationCubit = MockAppLocalizationCubit();

    when(appLocalizationCubit.state).thenAnswer((_) => AppLocale.values.first.buildSync());
  });

  tearDown(() async {
    await appLocalizationCubit.close();
  });

  group(PostContainerFooter, () {
    goldenTest(
      'renders correctly',
      fileName: 'post_container_footer'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: MockLocalization(
              appLocalizationCubit: appLocalizationCubit,
              child: PostContainerFooter(post: mockPost),
            ),
          ),
          GoldenTestScenario(
            name: 'with zero votes',
            child: MockLocalization(
              appLocalizationCubit: appLocalizationCubit,
              child: PostContainerFooter(
                post: mockPost.copyWith(upvotes: ValueNumeric(0, fieldName: 'upvotes')),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
