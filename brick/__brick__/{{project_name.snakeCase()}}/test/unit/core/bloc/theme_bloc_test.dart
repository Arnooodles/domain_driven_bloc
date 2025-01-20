import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/theme/theme_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

import '../../../utils/generated_mocks.mocks.dart';

void main() {
  late ThemeBloc themeBloc;
  late ILocalStorageRepository localStorageRepository;

  setUp(() {
    localStorageRepository = MockILocalStorageRepository();
  });

  tearDown(() {
    themeBloc.close();
    reset(localStorageRepository);
  });

  group('ThemeBloc initialize ', () {
    blocTest<ThemeBloc, ThemeMode>(
      'should emit a dark theme mode',
      setUp: () {
        when(localStorageRepository.getIsDarkMode())
            .thenAnswer((_) async => Future<bool>.value(true));
      },
      build: () => themeBloc = ThemeBloc(localStorageRepository),
      expect: () => <dynamic>[ThemeMode.dark],
      verify: (_) {
        verify(localStorageRepository.getIsDarkMode()).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeMode>(
      'should emit a dark theme mode',
      setUp: () {
        when(localStorageRepository.getIsDarkMode())
            .thenAnswer((_) async => Future<bool>.value(false));
      },
      build: () => themeBloc = ThemeBloc(localStorageRepository),
      expect: () => <dynamic>[ThemeMode.light],
      verify: (_) {
        verify(localStorageRepository.getIsDarkMode()).called(1);
      },
    );
  });

  group('ThemeBloc switchTheme ', () {
    setUp(() {
      themeBloc = ThemeBloc(localStorageRepository);
    });

    blocTest<ThemeBloc, ThemeMode>(
      'should emit a dark theme mode',
      build: () => themeBloc,
      setUp: () {
        when(localStorageRepository.setIsDarkMode(isDarkMode: false))
            .thenAnswer((_) async => Future.value);
      },
      act: (ThemeBloc bloc) async => bloc.switchTheme(Brightness.light),
      expect: () => <dynamic>[ThemeMode.dark],
      verify: (ThemeBloc bloc) {
        expect(bloc.isDarkMode, true);
      },
    );
    blocTest<ThemeBloc, ThemeMode>(
      'should emit a light theme mode',
      build: () => themeBloc,
      setUp: () {
        when(localStorageRepository.setIsDarkMode(isDarkMode: true))
            .thenAnswer((_) async => Future.value);
      },
      act: (ThemeBloc bloc) async => bloc.switchTheme(Brightness.dark),
      expect: () => <dynamic>[ThemeMode.light],
      verify: (ThemeBloc bloc) {
        expect(bloc.isDarkMode, false);
      },
    );
  });
}
