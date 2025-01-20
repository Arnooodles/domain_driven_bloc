import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

@lazySingleton
class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc(this.localStorageRepository) : super(ThemeMode.system) {
    initialize();
  }

  final ILocalStorageRepository localStorageRepository;

  Future<void> initialize() async {
    final bool? isDarkMode = await localStorageRepository.getIsDarkMode();
    if (isDarkMode != null) {
      safeEmit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    }
  }

  Future<void> switchTheme(Brightness currentBrightness) async {
    final bool isDarkMode = currentBrightness != Brightness.dark;
    await localStorageRepository.setIsDarkMode(isDarkMode: isDarkMode);
    safeEmit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
