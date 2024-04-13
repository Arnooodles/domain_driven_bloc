import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

final class AppUtils {
  AppUtils._();

  static void closeApp() {
    if (defaultTargetPlatform case TargetPlatform.android) {
      SystemNavigator.pop();
    } else if (defaultTargetPlatform case TargetPlatform.iOS) {
      exit(0);
    }
  }
}
