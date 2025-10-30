import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/cubit/app_core/app_core_cubit.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';

void main() {
  late AppCoreCubit appCoreCubit;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    appCoreCubit = AppCoreCubit();
    scrollControllers = <AppScrollController, ScrollController>{
      AppScrollController.home: ScrollController(debugLabel: AppScrollController.home.name),
      AppScrollController.profile: ScrollController(debugLabel: AppScrollController.profile.name),
    };
  });

  tearDown(() async {
    scrollControllers = <AppScrollController, ScrollController>{};
    await appCoreCubit.close();
  });

  group('initialize', () {
    blocTest<AppCoreCubit, AppCoreState>(
      'should emit initial state',
      build: () => appCoreCubit,
      act: (AppCoreCubit bloc) async => bloc.initialize(),
      expect: () => <AppCoreState>[],
    );
  });

  group('AppCore setScrollControllers', () {
    blocTest<AppCoreCubit, AppCoreState>(
      'should set scrollControllers',
      build: () => appCoreCubit,
      act: (AppCoreCubit bloc) async => bloc.setScrollControllers(scrollControllers),
      expect: () => <AppCoreState>[appCoreCubit.state.copyWith(scrollControllers: scrollControllers)],
    );
  });
}
