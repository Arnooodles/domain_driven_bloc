import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/theme/theme_cubit.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

import '../../../utils/generated_mocks.mocks.dart';

void main() {
  group(ThemeCubit, () {
    late ThemeCubit themeCubit;
    late ILocalStorageRepository localStorageRepository;
    late MockFailureHandler failureHandler;

    setUp(() {
      localStorageRepository = MockILocalStorageRepository();
      failureHandler = MockFailureHandler();
    });

    tearDown(() async {
      await themeCubit.close();
      reset(localStorageRepository);
      reset(failureHandler);
    });

    group('initialize', () {
      blocTest<ThemeCubit, ThemeMode>(
        'should emit dark theme mode when dark mode is enabled',
        setUp: () {
          provideDummy(Either<Failure, bool?>.right(true));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(right(true)));
        },
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        act: (ThemeCubit cubit) => cubit.initialize(),
        expect: () => <ThemeMode>[ThemeMode.dark],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should emit light theme mode when dark mode is disabled',
        setUp: () {
          provideDummy(Either<Failure, bool?>.right(false));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(right(false)));
        },
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        act: (ThemeCubit cubit) => cubit.initialize(),
        expect: () => <ThemeMode>[ThemeMode.light],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should handle device storage failure during initialize',
        setUp: () {
          const Failure failure = Failure.deviceStorage('Storage access denied');
          provideDummy(Either<Failure, bool?>.left(failure));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(left(failure)));
          when(failureHandler.handleFailure(any)).thenReturn(null);
        },
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        act: (ThemeCubit cubit) => cubit.initialize(),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
          verify(failureHandler.handleFailure(const Failure.deviceStorage('Storage access denied'))).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should handle unexpected failure during initialize',
        setUp: () {
          const Failure failure = Failure.unexpected('Unknown error occurred');
          provideDummy(Either<Failure, bool?>.left(failure));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(left(failure)));
          when(failureHandler.handleFailure(any)).thenReturn(null);
        },
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        act: (ThemeCubit cubit) => cubit.initialize(),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
          verify(failureHandler.handleFailure(const Failure.unexpected('Unknown error occurred'))).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should handle thrown exception during initialize',
        setUp: () {
          const Failure failure = Failure.unexpected('Exception: Unexpected storage crash');
          provideDummy(Either<Failure, bool?>.left(failure));
          when(localStorageRepository.getIsDarkMode()).thenThrow(Exception('Unexpected storage crash'));
          when(failureHandler.handleFailure(any)).thenReturn(null);
        },
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        act: (ThemeCubit cubit) => cubit.initialize(),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
          verify(
            failureHandler.handleFailure(const Failure.unexpected('Exception: Unexpected storage crash')),
          ).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should handle null value during initialize',
        setUp: () {
          provideDummy(Either<Failure, bool?>.right(null));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(right(null)));
        },
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        act: (ThemeCubit cubit) => cubit.initialize(),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
        },
      );
    });

    group('switchTheme', () {
      blocTest<ThemeCubit, ThemeMode>(
        'should switch to dark theme when current brightness is light',
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        setUp: () {
          provideDummy(Either<Failure, Unit>.right(unit));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(right(unit)));
        },
        act: (ThemeCubit cubit) => cubit.switchTheme(Brightness.light),
        expect: () => <ThemeMode>[ThemeMode.dark],
        verify: (ThemeCubit cubit) {
          expect(cubit.state, ThemeMode.dark);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should switch to light theme when current brightness is dark',
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        setUp: () {
          provideDummy(Either<Failure, Unit>.right(unit));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: true),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(right(unit)));
        },
        act: (ThemeCubit cubit) => cubit.switchTheme(Brightness.dark),
        expect: () => <ThemeMode>[ThemeMode.light],
        verify: (ThemeCubit cubit) {
          expect(cubit.state, ThemeMode.light);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should handle device storage failure during switchTheme',
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        setUp: () {
          const Failure failure = Failure.deviceStorage('Failed to save theme preference');
          provideDummy(Either<Failure, Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(left(failure)));
          when(failureHandler.handleFailure(any)).thenReturn(null);
        },
        act: (ThemeCubit cubit) => cubit.switchTheme(Brightness.light),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(
            failureHandler.handleFailure(const Failure.deviceStorage('Failed to save theme preference')),
          ).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should handle unexpected failure during switchTheme',
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        setUp: () {
          const Failure failure = Failure.unexpected('Network error during theme switch');
          provideDummy(Either<Failure, Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: true),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(left(failure)));
          when(failureHandler.handleFailure(any)).thenReturn(null);
        },
        act: (ThemeCubit cubit) => cubit.switchTheme(Brightness.dark),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(failureHandler.handleFailure(const Failure.unexpected('Network error during theme switch'))).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'should handle validation failure during switchTheme',
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        setUp: () {
          const Failure failure = Failure.validation(EmptyStringValidationError('theme', 'Invalid theme value'), '');
          provideDummy(Either<Failure, Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(left(failure)));
          when(failureHandler.handleFailure(any)).thenReturn(null);
        },
        act: (ThemeCubit cubit) => cubit.switchTheme(Brightness.light),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(
            failureHandler.handleFailure(
              const Failure.validation(EmptyStringValidationError('theme', 'Invalid theme value'), ''),
            ),
          ).called(1);
        },
      );
      blocTest<ThemeCubit, ThemeMode>(
        'should handle thrown exception during switchTheme',
        build: () => themeCubit = ThemeCubit(localStorageRepository, failureHandler),
        setUp: () {
          const Failure failure = Failure.unexpected('Exception: Unexpected network error');
          provideDummy(Either<Failure, Unit>.left(failure));
          when(localStorageRepository.setIsDarkMode(isDarkMode: true)).thenThrow(Exception('Unexpected network error'));
          when(failureHandler.handleFailure(any)).thenReturn(null);
        },
        act: (ThemeCubit cubit) => cubit.switchTheme(Brightness.light),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(
            failureHandler.handleFailure(const Failure.unexpected('Exception: Unexpected network error')),
          ).called(1);
        },
      );
    });
  });
}
