import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:logger/logger.dart';
import 'package:very_good_core/app/app.dart';
import 'package:very_good_core/app/generated/assets.gen.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/observers/app_bloc_observer.dart';
import 'package:very_good_core/core/domain/entity/enum/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Env env = Env.fromFlavor(isWeb: kIsWeb);
  await Future.wait(<Future<void>>[initializeEnvironmentConfig(env), configureDependencies(env)]);
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  if (kDebugMode) {
    Bloc.observer = getIt<AppBlocObserver>();
  }

  _handleErrors();

  runApp(App());
}

void _handleErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kReleaseMode) {
      //TODO: implement recordFlutterFatalError crashlytics
    } else {
      getIt<Logger>().f(details.exceptionAsString(), error: details, stackTrace: details.stack);
    }
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    if (kReleaseMode) {
      //TODO: implement reportCrash crashlytics
    } else {
      getIt<Logger>().f(error.toString(), error: error, stackTrace: stackTrace);
    }
    return true;
  };
}

Future<void> initializeEnvironmentConfig(Env env) async {
  switch (env) {
    case Env.development:
    case Env.test:
      await dotenv.load(fileName: Assets.env.aEnvDevelopment);
    case Env.staging:
      await dotenv.load(fileName: Assets.env.aEnvStaging);
    case Env.production:
      await dotenv.load(fileName: Assets.env.aEnvProduction);
  }
}
