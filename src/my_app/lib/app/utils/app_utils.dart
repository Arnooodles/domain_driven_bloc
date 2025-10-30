import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

final class AppUtils {
  AppUtils._();

  static Future<void> closeApp() async {
    if (defaultTargetPlatform case TargetPlatform.android) {
      await SystemNavigator.pop();
    } else if (defaultTargetPlatform case TargetPlatform.iOS) {
      exit(0);
    }
  }
}
