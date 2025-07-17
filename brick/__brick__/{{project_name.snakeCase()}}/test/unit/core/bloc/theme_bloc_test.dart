import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/failure_handler.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/theme/theme_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

import '../../../utils/generated_mocks.mocks.dart';

void main() {
  group('ThemeBloc', () {
    late ThemeBloc themeBloc;
    late ILocalStorageRepository localStorageRepository;
    late FailureHandler failureHandler;

    setUp(() {
      localStorageRepository = MockILocalStorageRepository();
      failureHandler = MockFailureHandler();
    });

    tearDown(() {
      themeBloc.close();
      reset(localStorageRepository);
      reset(failureHandler);
    });

    group('initialize', () {
      blocTest<ThemeBloc, ThemeMode>(
        'should emit dark theme mode when dark mode is enabled',
        setUp: () {
          provideDummy(Either<Failure, bool?>.right(true));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(right(true)));
        },
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        act: (ThemeBloc bloc) => bloc.initialize(),
        expect: () => <ThemeMode>[ThemeMode.dark],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should emit light theme mode when dark mode is disabled',
        setUp: () {
          provideDummy(Either<Failure, bool?>.right(false));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(right(false)));
        },
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        act: (ThemeBloc bloc) => bloc.initialize(),
        expect: () => <ThemeMode>[ThemeMode.light],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should handle device storage failure during initialize',
        setUp: () {
          const Failure failure = Failure.deviceStorage('Storage access denied');
          provideDummy(Either<Failure, bool?>.left(failure));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(left(failure)));
          when(failureHandler.handleFailure(failure)).thenReturn(null);
        },
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        act: (ThemeBloc bloc) => bloc.initialize(),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
          verify(failureHandler.handleFailure(const Failure.deviceStorage('Storage access denied'))).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should handle unexpected failure during initialize',
        setUp: () {
          const Failure failure = Failure.unexpected('Unknown error occurred');
          provideDummy(Either<Failure, bool?>.left(failure));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(left(failure)));
          when(failureHandler.handleFailure(failure)).thenReturn(null);
        },
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        act: (ThemeBloc bloc) => bloc.initialize(),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
          verify(failureHandler.handleFailure(const Failure.unexpected('Unknown error occurred'))).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should handle null value during initialize',
        setUp: () {
          provideDummy(Either<Failure, bool?>.right(null));
          when(
            localStorageRepository.getIsDarkMode(),
          ).thenAnswer((_) async => Future<Either<Failure, bool?>>.value(right(null)));
        },
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        act: (ThemeBloc bloc) => bloc.initialize(),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(localStorageRepository.getIsDarkMode()).called(1);
        },
      );
    });

    group('switchTheme', () {
      blocTest<ThemeBloc, ThemeMode>(
        'should switch to dark theme when current brightness is light',
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        setUp: () {
          provideDummy(Either<Failure, Unit>.right(unit));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(right(unit)));
        },
        act: (ThemeBloc bloc) => bloc.switchTheme(Brightness.light),
        expect: () => <ThemeMode>[ThemeMode.dark],
        verify: (ThemeBloc bloc) {
          expect(bloc.isDarkMode, isTrue);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should switch to light theme when current brightness is dark',
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        setUp: () {
          provideDummy(Either<Failure, Unit>.right(unit));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: true),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(right(unit)));
        },
        act: (ThemeBloc bloc) => bloc.switchTheme(Brightness.dark),
        expect: () => <ThemeMode>[ThemeMode.light],
        verify: (ThemeBloc bloc) {
          expect(bloc.isDarkMode, isFalse);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should handle device storage failure during switchTheme',
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        setUp: () {
          const Failure failure = Failure.deviceStorage('Failed to save theme preference');
          provideDummy(Either<Failure, Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(left(failure)));
          when(failureHandler.handleFailure(failure)).thenReturn(null);
        },
        act: (ThemeBloc bloc) => bloc.switchTheme(Brightness.light),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(
            failureHandler.handleFailure(const Failure.deviceStorage('Failed to save theme preference')),
          ).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should handle unexpected failure during switchTheme',
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        setUp: () {
          const Failure failure = Failure.unexpected('Network error during theme switch');
          provideDummy(Either<Failure, Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: true),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(left(failure)));
          when(failureHandler.handleFailure(failure)).thenReturn(null);
        },
        act: (ThemeBloc bloc) => bloc.switchTheme(Brightness.dark),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(failureHandler.handleFailure(const Failure.unexpected('Network error during theme switch'))).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeMode>(
        'should handle validation failure during switchTheme',
        build: () => themeBloc = ThemeBloc(localStorageRepository, failureHandler),
        setUp: () {
          const Failure failure = Failure.validation(EmptyStringValidationError('theme', 'Invalid theme value'));
          provideDummy(Either<Failure, Unit>.left(failure));
          when(
            localStorageRepository.setIsDarkMode(isDarkMode: false),
          ).thenAnswer((_) async => Future<Either<Failure, Unit>>.value(left(failure)));
          when(failureHandler.handleFailure(failure)).thenReturn(null);
        },
        act: (ThemeBloc bloc) => bloc.switchTheme(Brightness.light),
        expect: () => <ThemeMode>[],
        verify: (_) {
          verify(
            failureHandler.handleFailure(
              const Failure.validation(EmptyStringValidationError('theme', 'Invalid theme value')),
            ),
          ).called(1);
        },
      );
    });
  });
}
