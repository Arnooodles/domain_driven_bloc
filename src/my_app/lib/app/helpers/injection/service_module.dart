import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_chopper_logger/talker_chopper_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:very_good_core/app/config/chopper_config.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/core/data/service/user_service.dart';
import 'package:very_good_core/features/auth/data/service/auth_service.dart';
import 'package:very_good_core/features/home/data/service/post_service.dart';

@module
abstract class ServiceModule {
  //Local Storage Service
  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  @lazySingleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

  //Device Service
  @lazySingleton
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @lazySingleton
  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  // Logging
  @lazySingleton
  Talker get talker => Talker(
    settings: TalkerSettings(
      colors: <String, AnsiPen>{
        TalkerKey.error: AnsiPen()..red(),
        TalkerKey.exception: AnsiPen()..red(),
        TalkerKey.blocTransition: AnsiPen()..blue(),
        TalkerKey.httpRequest: AnsiPen()..green(),
        TalkerKey.httpResponse: AnsiPen()..yellow(),
        TalkerKey.httpError: AnsiPen()..magenta(),
        TalkerKey.route: AnsiPen()..cyan(),
      },
      titles: <String, String>{
        TalkerKey.blocTransition: 'Cubit',
        TalkerKey.httpRequest: 'HTTP:Request',
        TalkerKey.httpResponse: 'HTTP:Response',
        TalkerKey.httpError: 'HTTP:Error',
        TalkerKey.route: 'GoRoute',
        TalkerKey.exception: 'EXCEPTION',
        TalkerKey.error: 'ERROR',
      },
    ),
  );

  @lazySingleton
  TalkerBlocObserver get talkerBlocObserver => TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(printEventFullData: false, printChanges: true),
  );

  @lazySingleton
  TalkerRouteObserver get talkerRouteObserver => TalkerRouteObserver(talker);

  @lazySingleton
  TalkerChopperLogger get talkerChopperLogger => TalkerChopperLogger(
    talker: talker,
    settings: const TalkerChopperLoggerSettings(printRequestHeaders: true, printResponseHeaders: true),
  );

  //API Service
  @lazySingleton
  ChopperClient get chopperClient => getIt<ChopperConfig>().client;

  @lazySingleton
  AuthService get authService => chopperClient.getService<AuthService>();

  @lazySingleton
  UserService get userService => chopperClient.getService<UserService>();

  @lazySingleton
  PostService get postService => chopperClient.getService<PostService>();
}
