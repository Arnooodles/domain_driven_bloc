import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/app_core/app_core_cubit.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';

import '../../../utils/generated_mocks.mocks.dart';

void main() {
  group(AppCoreCubit, () {
    late MockFailureHandler failureHandler;
    late MockIAssetRepository assetRepository;

    setUp(() {
      failureHandler = MockFailureHandler();
      assetRepository = MockIAssetRepository();
    });

    tearDown(() {
      reset(failureHandler);
    });

    group('initialize', () {
      blocTest<AppCoreCubit, AppCoreState>(
        'should complete without emitting states',
        build: () => AppCoreCubit(failureHandler, assetRepository),
        act: (AppCoreCubit cubit) async => cubit.initialize(),
        expect: () => <AppCoreState>[],
      );

      blocTest<AppCoreCubit, AppCoreState>(
        'should handle unexpected error',
        setUp: () {
          when(assetRepository.preloadSVGs()).thenThrow(Exception('error'));
        },
        build: () => AppCoreCubit(failureHandler, assetRepository),
        act: (AppCoreCubit cubit) async => cubit.initialize(),
        verify: (_) {
          verify(failureHandler.handleFailure(const Failure.unexpected('Exception: error'))).called(1);
        },
      );
    });
  });
}
