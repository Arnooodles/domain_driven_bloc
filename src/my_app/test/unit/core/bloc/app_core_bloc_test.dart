import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/route_name.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';

void main() {
  late AppCoreBloc appCoreBloc;

  setUp(() {
    appCoreBloc = AppCoreBloc();
  });

  group('AppCore initializeScrollControllers', () {
    test(
      'should initialize a scroll controllers',
      () {
        appCoreBloc.initialize();

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
          appCoreBloc.getScrollController(RouteName.home.name),
          isA<ScrollController>(),
        );

        expect(
          appCoreBloc.getScrollController(RouteName.profile.name),
          isA<ScrollController>(),
        );
      },
    );
  });
}
