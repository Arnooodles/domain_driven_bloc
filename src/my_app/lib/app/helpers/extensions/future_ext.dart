import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';

extension FutureExt<T> on Future<T> {
  /// Catches errors and logs them in debug mode.
  ///
  /// Returns the original future for chaining.
  Future<T> logOnError() => catchError((Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      getIt<Logger>().e('Error: $error', stackTrace: stackTrace);
    } else {
      //TODO: implement reportCrash crashlytics
    }
  });
}
