import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/app_localization/app_localization_cubit.dart';

import '../../../utils/generated_mocks.mocks.dart';

void main() {
  late MockIAppLocalizationRepository mockIAppLocalizationRepository;

  setUp(() {
    mockIAppLocalizationRepository = MockIAppLocalizationRepository();
  });

  group(AppLocalizationCubit, () {
    group('initialize', () {
      blocTest<AppLocalizationCubit, I18n>(
        'should emit an I18n state',
        setUp: () {
          when(mockIAppLocalizationRepository.findDeviceLocale()).thenReturn(AppLocale.en);
        },
        build: () => AppLocalizationCubit(mockIAppLocalizationRepository),
        act: (AppLocalizationCubit cubit) => cubit.initialize(),
        expect: () => <dynamic>[isA<I18n>()],
      );

      blocTest<AppLocalizationCubit, I18n>(
        'should emit first locale when device locale detection fails',
        setUp: () {
          when(
            mockIAppLocalizationRepository.findDeviceLocale(),
          ).thenThrow(Exception('Device locale detection failed'));
        },
        build: () => AppLocalizationCubit(mockIAppLocalizationRepository),
        act: (AppLocalizationCubit cubit) => cubit.initialize(),
        expect: () => <dynamic>[isA<I18n>()],
      );
    });
  });
}
