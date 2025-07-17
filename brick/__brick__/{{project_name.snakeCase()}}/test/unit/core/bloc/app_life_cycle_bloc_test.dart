import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';

void main() {
  group('AppLifeCycleBloc', () {
    late AppLifeCycleBloc appLifeCycleBloc;

    setUp(() {
      appLifeCycleBloc = AppLifeCycleBloc();
    });

    tearDown(() {
      appLifeCycleBloc.close();
    });

    void setAppLifeCycleState(AppLifecycleState state) =>
        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(state);

    group('lifecycle state changes', () {
      blocTest<AppLifeCycleBloc, AppLifeCycleState>(
        'should emit detached state when app becomes detached',
        build: () => appLifeCycleBloc,
        act: (AppLifeCycleBloc bloc) => setAppLifeCycleState(AppLifecycleState.detached),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.detached()],
        verify: (_) {
          expect(appLifeCycleBloc.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleBloc, AppLifeCycleState>(
        'should emit inactive state when app becomes inactive',
        build: () => appLifeCycleBloc,
        act: (AppLifeCycleBloc bloc) => setAppLifeCycleState(AppLifecycleState.inactive),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.inactive()],
        verify: (_) {
          expect(appLifeCycleBloc.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleBloc, AppLifeCycleState>(
        'should emit hidden state when app becomes hidden',
        build: () => appLifeCycleBloc,
        act: (AppLifeCycleBloc bloc) => setAppLifeCycleState(AppLifecycleState.hidden),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.hidden()],
        verify: (_) {
          expect(appLifeCycleBloc.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleBloc, AppLifeCycleState>(
        'should emit paused state when app becomes paused',
        build: () => appLifeCycleBloc,
        act: (AppLifeCycleBloc bloc) => setAppLifeCycleState(AppLifecycleState.paused),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.paused()],
        verify: (_) {
          expect(appLifeCycleBloc.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleBloc, AppLifeCycleState>(
        'should emit resumed state when app becomes resumed',
        build: () => appLifeCycleBloc,
        act: (AppLifeCycleBloc bloc) => setAppLifeCycleState(AppLifecycleState.resumed),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.resumed()],
        verify: (_) {
          expect(appLifeCycleBloc.state, isA<AppLifeCycleState>());
        },
      );
    });

    group('state transitions', () {
      blocTest<AppLifeCycleBloc, AppLifeCycleState>(
        'should handle multiple state transitions correctly',
        build: () => appLifeCycleBloc,
        act: (AppLifeCycleBloc bloc) async {
          setAppLifeCycleState(AppLifecycleState.paused);
          setAppLifeCycleState(AppLifecycleState.resumed);
          setAppLifeCycleState(AppLifecycleState.inactive);
        },
        expect: () => const <AppLifeCycleState>[
          AppLifeCycleState.paused(),
          AppLifeCycleState.resumed(),
          AppLifeCycleState.inactive(),
        ],
        verify: (_) {
          expect(appLifeCycleBloc.state, const AppLifeCycleState.inactive());
        },
      );

      blocTest<AppLifeCycleBloc, AppLifeCycleState>(
        'should maintain correct state after rapid transitions',
        build: () => appLifeCycleBloc,
        act: (AppLifeCycleBloc bloc) async {
          setAppLifeCycleState(AppLifecycleState.detached);
          setAppLifeCycleState(AppLifecycleState.hidden);
        },
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.detached(), AppLifeCycleState.hidden()],
        verify: (_) {
          expect(appLifeCycleBloc.state, const AppLifeCycleState.hidden());
        },
      );
    });
  });
}
