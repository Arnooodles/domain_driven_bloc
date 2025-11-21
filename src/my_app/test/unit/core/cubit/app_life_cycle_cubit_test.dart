import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/cubit/app_life_cycle/app_life_cycle_cubit.dart';

void main() {
  group(AppLifeCycleCubit, () {
    void setAppLifeCycleState(AppLifecycleState state) =>
        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(state);

    group('lifecycle state changes', () {
      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit detached state when app becomes detached',
        build: AppLifeCycleCubit.new,
        act: (AppLifeCycleCubit cubit) => setAppLifeCycleState(AppLifecycleState.detached),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.detached()],
        verify: (AppLifeCycleCubit cubit) {
          expect(cubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit inactive state when app becomes inactive',
        build: AppLifeCycleCubit.new,
        act: (AppLifeCycleCubit cubit) => setAppLifeCycleState(AppLifecycleState.inactive),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.inactive()],
        verify: (AppLifeCycleCubit cubit) {
          expect(cubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit hidden state when app becomes hidden',
        build: AppLifeCycleCubit.new,
        act: (AppLifeCycleCubit cubit) => setAppLifeCycleState(AppLifecycleState.hidden),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.hidden()],
        verify: (AppLifeCycleCubit cubit) {
          expect(cubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit paused state when app becomes paused',
        build: AppLifeCycleCubit.new,
        act: (AppLifeCycleCubit cubit) => setAppLifeCycleState(AppLifecycleState.paused),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.paused()],
        verify: (AppLifeCycleCubit cubit) {
          expect(cubit.state, isA<AppLifeCycleState>());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should emit resumed state when app becomes resumed',
        build: AppLifeCycleCubit.new,
        act: (AppLifeCycleCubit cubit) => setAppLifeCycleState(AppLifecycleState.resumed),
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.resumed()],
        verify: (AppLifeCycleCubit cubit) {
          expect(cubit.state, isA<AppLifeCycleState>());
        },
      );
    });

    group('state transitions', () {
      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should handle multiple state transitions correctly',
        build: AppLifeCycleCubit.new,
        act: (AppLifeCycleCubit cubit) async {
          setAppLifeCycleState(AppLifecycleState.paused);
          setAppLifeCycleState(AppLifecycleState.resumed);
          setAppLifeCycleState(AppLifecycleState.inactive);
        },
        expect: () => const <AppLifeCycleState>[
          AppLifeCycleState.paused(),
          AppLifeCycleState.resumed(),
          AppLifeCycleState.inactive(),
        ],
        verify: (AppLifeCycleCubit cubit) {
          expect(cubit.state, const AppLifeCycleState.inactive());
        },
      );

      blocTest<AppLifeCycleCubit, AppLifeCycleState>(
        'should maintain correct state after rapid transitions',
        build: AppLifeCycleCubit.new,
        act: (AppLifeCycleCubit cubit) async {
          setAppLifeCycleState(AppLifecycleState.detached);
          setAppLifeCycleState(AppLifecycleState.hidden);
        },
        expect: () => const <AppLifeCycleState>[AppLifeCycleState.detached(), AppLifeCycleState.hidden()],
        verify: (AppLifeCycleCubit cubit) {
          expect(cubit.state, const AppLifeCycleState.hidden());
        },
      );
    });
  });
}
