import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:trust_but_verify/trust_but_verify.dart';
import 'package:very_good_core/core/domain/cubit/theme/theme_cubit.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';

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
          provideDummy(Result<bool?>.right(true));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Result<bool?>>.value(right(true)));
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
          provideDummy(Result<bool?>.right(false));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Result<bool?>>.value(right(false)));
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
          provideDummy(Result<bool?>.left(failure));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Result<bool?>>.value(left(failure)));
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
          provideDummy(Result<bool?>.left(failure));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Result<bool?>>.value(left(failure)));
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
          provideDummy(Result<bool?>.left(failure));
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
          provideDummy(Result<bool?>.right(null));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Result<bool?>>.value(right(null)));
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
          provideDummy(Result<Unit>.right(unit));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Result<Unit>>.value(right(unit)));
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
          provideDummy(Result<Unit>.right(unit));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: true),
          ).thenAnswer((_) async => Future<Result<Unit>>.value(right(unit)));
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
          provideDummy(Result<Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Result<Unit>>.value(left(failure)));
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
          provideDummy(Result<Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: true),
          ).thenAnswer((_) async => Future<Result<Unit>>.value(left(failure)));
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
          provideDummy(Result<Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Result<Unit>>.value(left(failure)));
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
          provideDummy(Result<Unit>.left(failure));
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
