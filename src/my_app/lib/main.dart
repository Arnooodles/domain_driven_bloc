import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:very_good_core/app/app.dart';
import 'package:very_good_core/app/config/url_strategy_native.dart'
    if (dart.library.html) 'package:very_good_core/app/config/url_strategy_web.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/observers/app_bloc_observer.dart';
import 'package:very_good_core/core/domain/entity/enum/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(Env.fromFlavor(isWeb: kIsWeb));
  urlConfig();
  _handleErrors();

  if (kDebugMode) {
    Bloc.observer = getIt<AppBlocObserver>();
  }

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
