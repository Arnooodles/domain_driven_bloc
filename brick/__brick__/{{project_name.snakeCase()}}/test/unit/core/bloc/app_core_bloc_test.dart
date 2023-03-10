import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';

void main() {
  late AppCoreBloc appCoreBloc;

  setUp(() {
    appCoreBloc = AppCoreBloc();
  });

  group('AppCore initializeScrollControllers', () {
    test(
      'should initialize a scroll controllers',
      () {
        appCoreBloc.initializeScrollControllers();

        expect(
          appCoreBloc.state.scrollControllers[AppScrollController.home],
          isA<ScrollController>(),
        );
        expect(
          appCoreBloc.state.scrollControllers[AppScrollController.profile],
          isA<ScrollController>(),
        );
      },
    );
  });

  group('AppCore getScrollControllers', () {
    test(
      'should return a scroll controllers',
      () {
        expect(
          appCoreBloc.getScrollController(AppScrollController.home),
          isA<ScrollController>(),
        );
        expect(
          appCoreBloc.getScrollController(AppScrollController.profile),
          isA<ScrollController>(),
        );
      },
    );
  });

  group('AppCore setScrollControllers', () {
    test(
      'should set a scroll controllers',
      () {
        appCoreBloc.setScrollController(
          AppScrollController.home,
          ScrollController(),
        );
        expect(
          appCoreBloc.state.scrollControllers[AppScrollController.home],
          isA<ScrollController>(),
        );
        appCoreBloc.setScrollController(
          AppScrollController.profile,
          ScrollController(),
        );
        expect(
          appCoreBloc.state.scrollControllers[AppScrollController.profile],
          isA<ScrollController>(),
        );
      },
    );
  });
}
