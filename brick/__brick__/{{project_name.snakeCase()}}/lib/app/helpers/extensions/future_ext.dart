import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';

extension FutureExt<T> on Future<T> {
  /// Catches errors and logs them in debug mode.
  ///
  /// Returns the original future for chaining.
  Future<T> logOnError() => catchError((Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      getIt<Talker>().handle(error, stackTrace);
    } else {
      //TODO: implement reportCrash crashlytics
    }
  });
}
