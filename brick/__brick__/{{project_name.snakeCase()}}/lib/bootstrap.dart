import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:{{project_name.snakeCase()}}/app/config/chopper_config.dart';
import 'package:{{project_name.snakeCase()}}/app/config/url_strategy_native.dart'
    if (dart.library.html) 'package:{{project_name.snakeCase()}}/app/config/url_strategy_web.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/assets.gen.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection.dart';
import 'package:{{project_name.snakeCase()}}/app/observers/app_bloc_observer.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder, Env env) async {
  urlConfig();
  initializeSingletons();
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(<Future<void>>[
    initializeEnvironmentConfig(env),
    configureDependencies(env),
  ]);

  Bloc.observer = getIt<AppBlocObserver>();
  FlutterError.onError = (FlutterErrorDetails details) {
    getIt<Logger>().f(
      details.exceptionAsString(),
      error: details,
      stackTrace: details.stack,
    );
  };

  runApp(await builder());
}

void initializeSingletons() {
  getIt
    ..registerLazySingleton<Logger>(
      () => Logger(
        filter: ProductionFilter(),
        printer: PrettyPrinter(),
        output: ConsoleOutput(),
      ),
    )
    ..registerLazySingleton<ChopperClient>(
      () => ChopperConfig().client,
    );
}

Future<void> initializeEnvironmentConfig(Env env) async {
  switch (env) {
    case Env.development:
    case Env.test:
      await dotenv.load(fileName: Assets.env.envDevelopment);
    case Env.staging:
      await dotenv.load(fileName: Assets.env.envStaging);
    case Env.production:
      await dotenv.load(fileName: Assets.env.envProduction);
  }
}
