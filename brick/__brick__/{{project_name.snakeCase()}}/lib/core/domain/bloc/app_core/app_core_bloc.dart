import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';

part 'app_core_bloc.freezed.dart';
part 'app_core_state.dart';

@lazySingleton
class AppCoreBloc extends Cubit<AppCoreState> {
  AppCoreBloc() : super(AppCoreState.initial()) {
    initialize();
  }

  void initialize() {
    initializeScrollControllers();
  }

  void initializeScrollControllers() {
    final Map<AppScrollController, ScrollController> controllers =
        <AppScrollController, ScrollController>{};

    for (final AppScrollController appScrollController
        in AppScrollController.values) {
      controllers.putIfAbsent(appScrollController, ScrollController.new);
    }
    emit(state.copyWith(scrollControllers: controllers));
  }

  ScrollController getScrollController(
    AppScrollController appScrollController,
  ) {
    ScrollController? scrollController =
        state.scrollControllers[appScrollController];
    if (scrollController == null) {
      scrollController = ScrollController();
      setScrollController(appScrollController, scrollController);
    }

    return scrollController;
  }

  void setScrollController(
    AppScrollController appScrollController,
    ScrollController scrollController,
  ) {
    final Map<AppScrollController, ScrollController> scrollControllers =
        Map<AppScrollController, ScrollController>.from(
      state.scrollControllers,
    );

    emit(
      state.copyWith(
        scrollControllers: scrollControllers
          ..putIfAbsent(appScrollController, () => scrollController),
      ),
    );
  }
}
