import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc() : super(ThemeMode.system);

  void switchTheme(Brightness brightness) => emit(
        brightness == Brightness.dark //
            ? ThemeMode.light
            : ThemeMode.dark,
      );
}
