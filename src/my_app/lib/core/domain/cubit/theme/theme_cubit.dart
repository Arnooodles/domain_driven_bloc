// ignore_for_file: prefer-bloc-state-suffix, avoid_flutter_imports

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._localStorageRepository, this._failureHandler) : super(ThemeMode.system);

  final ILocalStorageRepository _localStorageRepository;
  final FailureHandler _failureHandler;

  Future<void> initialize() async {
    try {
      final Result<bool?> possibleFailure = await _localStorageRepository.getIsDarkMode();
      possibleFailure.fold(_failureHandler.handleFailure, (bool? isDarkMode) {
        if (isDarkMode != null) {
          safeEmit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
        }
      });
    } on Exception catch (error) {
      _failureHandler.handleFailure(Failure.unexpected(error.toString()));
    }
  }

  Future<void> switchTheme(Brightness currentBrightness) async {
    try {
      final bool isDarkMode = currentBrightness != Brightness.dark;
      final Result<Unit> possibleFailure = await _localStorageRepository.setIsDarkMode(isDarkMode: isDarkMode);
      possibleFailure.fold(_failureHandler.handleFailure, (_) {
        safeEmit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
        // Change system bar brightness
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Only Android
            statusBarBrightness: isDarkMode
                ? Brightness.dark
                : Brightness.light, // Only iOS (Note: light and dark are inverted for iOS)
            statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, // Only Android
          ),
        );
      });
    } on Exception catch (error) {
      _failureHandler.handleFailure(Failure.unexpected(error.toString()));
    }
  }
}
