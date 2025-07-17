import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';

void main() {
  late AppCoreBloc appCoreBloc;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    appCoreBloc = AppCoreBloc();
    scrollControllers = <AppScrollController, ScrollController>{
      AppScrollController.home: ScrollController(debugLabel: AppScrollController.home.name),
      AppScrollController.profile: ScrollController(debugLabel: AppScrollController.profile.name),
    };
  });

  tearDown(() {
    scrollControllers = <AppScrollController, ScrollController>{};
    appCoreBloc.close();
  });

  group('initialize', () {
    blocTest<AppCoreBloc, AppCoreState>(
      'should emit initial state',
      build: () => appCoreBloc,
      act: (AppCoreBloc bloc) async => bloc.initialize(),
      expect: () => <AppCoreState>[],
    );
  });

  group('AppCore setScrollControllers', () {
    blocTest<AppCoreBloc, AppCoreState>(
      'should set scrollControllers',
      build: () => appCoreBloc,
      act: (AppCoreBloc bloc) async => bloc.setScrollControllers(scrollControllers),
      expect: () => <AppCoreState>[appCoreBloc.state.copyWith(scrollControllers: scrollControllers)],
    );
  });
}
