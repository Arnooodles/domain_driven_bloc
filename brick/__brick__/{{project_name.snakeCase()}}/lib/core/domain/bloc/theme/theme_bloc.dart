// ignore_for_file: prefer-bloc-state-suffix

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/failure_handler.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

@lazySingleton
class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc(this._localStorageRepository, this._failureHandler) : super(ThemeMode.system);

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

  bool get isDarkMode => state == ThemeMode.dark;
}
