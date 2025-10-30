// ignore_for_file: prefer-bloc-state-suffix, avoid_flutter_imports

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._localStorageRepository, this._failureHandler) : super(ThemeMode.system) {
    unawaited(initialize());
  }

  final ILocalStorageRepository _localStorageRepository;
  final FailureHandler _failureHandler;

  Future<void> initialize() async {
    final Either<Failure, bool?> possibleFailure = await _localStorageRepository.getIsDarkMode();
    possibleFailure.fold(_failureHandler.handleFailure, (bool? isDarkMode) {
      if (isDarkMode != null) {
        safeEmit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
      }
    });
  }

  Future<void> switchTheme(Brightness currentBrightness) async {
    final bool isDarkMode = currentBrightness != Brightness.dark;
    final Either<Failure, Unit> possibleFailure = await _localStorageRepository.setIsDarkMode(isDarkMode: isDarkMode);
    possibleFailure.fold(_failureHandler.handleFailure, (_) {
      safeEmit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    });
  }
}
