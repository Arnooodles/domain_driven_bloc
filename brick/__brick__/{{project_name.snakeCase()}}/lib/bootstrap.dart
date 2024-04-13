import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:{{project_name.snakeCase()}}/app/config/url_strategy_native.dart'
    if (dart.library.html) 'package:{{project_name.snakeCase()}}/app/config/url_strategy_web.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/assets.gen.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/observers/app_bloc_observer.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder, Env env) async {
  WidgetsFlutterBinding.ensureInitialized();
  urlConfig();
  await Future.wait(<Future<void>>[
    initializeEnvironmentConfig(env),
    configureDependencies(env),
  ]);

  if (kDebugMode) {
    Bloc.observer = getIt<AppBlocObserver>();
  }

  _handleErrors();

  runApp(await builder());
}

void _handleErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    getIt<Logger>().f(
      details.exceptionAsString(),
      error: details,
      stackTrace: details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    getIt<Logger>().f(
      error.toString(),
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };
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
