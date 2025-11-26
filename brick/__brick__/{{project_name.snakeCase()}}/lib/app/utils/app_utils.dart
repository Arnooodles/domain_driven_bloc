import 'dart:async';

import 'package:flutter/services.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/future_ext.dart';

final class AppUtils {
  AppUtils._();

  static void closeApp() {
    unawaited(SystemNavigator.pop().logOnError());
  }
}
