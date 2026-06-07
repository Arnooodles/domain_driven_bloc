// ignore_for_file: avoid_flutter_imports

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';

part 'app_life_cycle_cubit.freezed.dart';
part 'app_life_cycle_state.dart';

@lazySingleton
class AppLifeCycleCubit extends Cubit<AppLifeCycleState> with WidgetsBindingObserver {
  AppLifeCycleCubit(this._talker) : super(AppLifeCycleState.initialize(WidgetsBinding.instance.lifecycleState)) {
    WidgetsBinding.instance.addObserver(this);
  }

  final Talker _talker;

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        safeEmit(const AppLifeCycleState.resumed());
      case AppLifecycleState.paused:
        safeEmit(const AppLifeCycleState.paused());
      case AppLifecycleState.inactive:
        safeEmit(const AppLifeCycleState.inactive());
      case AppLifecycleState.detached:
        safeEmit(const AppLifeCycleState.detached());
      case AppLifecycleState.hidden:
        safeEmit(const AppLifeCycleState.hidden());
    }
    if (kDebugMode) {
      _talker.debug('AppLifeCycleState: $state');
    }
  }
}
