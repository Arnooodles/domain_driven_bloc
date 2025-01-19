import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  //Device Service
  @lazySingleton
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @lazySingleton
  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  @lazySingleton
  Logger get logger => Logger(
        filter: ProductionFilter(),
        printer: PrettyPrinter(methodCount: 0),
        output: ConsoleOutput(),
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
