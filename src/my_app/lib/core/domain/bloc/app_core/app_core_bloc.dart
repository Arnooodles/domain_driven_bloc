import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/route_name.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';

part 'app_core_bloc.freezed.dart';
part 'app_core_state.dart';

@lazySingleton
class AppCoreBloc extends Cubit<AppCoreState> {
  AppCoreBloc() : super(AppCoreState.initial()) {
    initialize();
  }

  void initialize() {
    final Map<AppScrollController, ScrollController> controllers =
        <AppScrollController, ScrollController>{};

    for (final AppScrollController appScrollController
        in AppScrollController.values) {
      controllers.putIfAbsent(appScrollController, ScrollController.new);
    }
    safeEmit(state.copyWith(scrollControllers: controllers));
  }

  ScrollController getScrollController(String route) {
    ScrollController? scrollController;
    if (route == RouteName.home.path) {
      scrollController = state.scrollControllers[AppScrollController.home];
    } else if (route == RouteName.profile.path) {
      scrollController = state.scrollControllers[AppScrollController.profile];
    }

    return scrollController ?? ScrollController();
  }
}
