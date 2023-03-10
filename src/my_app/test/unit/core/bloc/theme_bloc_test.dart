import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';

void main() {
  late ThemeBloc themeBloc;

  setUp(() {
    themeBloc = ThemeBloc();
  });

  group('ThemeBloc switchTheme ', () {
    blocTest<ThemeBloc, ThemeMode>(
      'should emit a dark theme mode',
      build: () => themeBloc,
      act: (ThemeBloc bloc) async => bloc.switchTheme(Brightness.light),
      expect: () => <dynamic>[ThemeMode.dark],
    );
    blocTest<ThemeBloc, ThemeMode>(
      'should emit a light theme mode',
      build: () => themeBloc,
      act: (ThemeBloc bloc) async => bloc.switchTheme(Brightness.dark),
      expect: () => <dynamic>[ThemeMode.light],
    );
  });
}
