import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/cubit/app_life_cycle/app_life_cycle_cubit.dart';

void main() {
  group('AppLifeCycleCubit', () {
    late AppLifeCycleCubit appLifeCycleCubit;

    setUp(() {
      appLifeCycleCubit = AppLifeCycleCubit();
    });

    tearDown(() async {
      await appLifeCycleCubit.close();
    });

    void setAppLifeCycleState(AppLifecycleState state) =>
        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(state);

    group('lifecycle state changes', () {
      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit detached state when app becomes detached',
        build: () => appLifeCycleCubit,
        act: (AppLifeCycleCubit bloc) => setAppLifeCycleState(AppLifecycleState.detached),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.detached()],
        verify: (_) {
          expect(appLifeCycleCubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit inactive state when app becomes inactive',
        build: () => appLifeCycleCubit,
        act: (AppLifeCycleCubit bloc) => setAppLifeCycleState(AppLifecycleState.inactive),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.inactive()],
        verify: (_) {
          expect(appLifeCycleCubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit hidden state when app becomes hidden',
        build: () => appLifeCycleCubit,
        act: (AppLifeCycleCubit bloc) => setAppLifeCycleState(AppLifecycleState.hidden),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.hidden()],
        verify: (_) {
          expect(appLifeCycleCubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit paused state when app becomes paused',
        build: () => appLifeCycleCubit,
        act: (AppLifeCycleCubit bloc) => setAppLifeCycleState(AppLifecycleState.paused),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.paused()],
        verify: (_) {
          expect(appLifeCycleCubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit resumed state when app becomes resumed',
        build: () => appLifeCycleCubit,
        act: (AppLifeCycleCubit bloc) => setAppLifeCycleState(AppLifecycleState.resumed),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.resumed()],
        verify: (_) {
          expect(appLifeCycleCubit.state, isA<AppLifeCycleState>());
        },
      );
    });

    group('state transitions', () {
      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should handle multiple state transitions correctly',
        build: () => appLifeCycleCubit,
        act: (AppLifeCycleCubit bloc) async {
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
          expect(appLifeCycleCubit.state, const AppLifeCycleState.inactive());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should maintain correct state after rapid transitions',
        build: () => appLifeCycleCubit,
        act: (AppLifeCycleCubit bloc) async {
          setAppLifeCycleState(AppLifecycleState.detached);
          setAppLifeCycleState(AppLifecycleState.hidden);
        },
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.detached(), AppLifeCycleState.hidden()],
        verify: (_) {
          expect(appLifeCycleCubit.state, const AppLifeCycleState.hidden());
        },
      );
    });
  });
}
