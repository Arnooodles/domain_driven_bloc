import 'dart:convert';

import 'package:chopper/chopper.dart' as chopper;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:{{project_name.snakeCase()}}/app/config/chopper_config.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/bootstrap.dart';
import 'package:{{project_name.snakeCase()}}/core/data/dto/user.dto.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/dto/post.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

import '../flutter_test_config.dart';
import 'mock_path_provider_platform.dart';

// ignore_for_file: depend_on_referenced_packages
Future<void> setupInjection() async {
  await getIt.reset();
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = MockPathProviderPlatform();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  _mockPackageInfo();
  await Future.wait(<Future<void>>[
    initializeEnvironmentConfig(Env.test),
    configureDependencies(Env.test),
  ]);
}

void _mockPackageInfo() {
  PackageInfo.setMockInitialValues(
    appName: Constant.appName,
    packageName: 'com.example.example',
    version: '1.0',
    buildNumber: '1',
    buildSignature: 'buildSignature',
  );
}

AndroidDeviceInfo mockAndroidDeviceInfo({
  String? phoneModel,
  String? version,
}) =>
    AndroidDeviceInfo.fromMap(<String, dynamic>{
      'model': phoneModel ?? 'model',
      'version': <String, dynamic>{
        'baseOS': 'baseOS',
        'codename': 'codename',
        'incremental': 'incremental',
        'previewSdkInt': 1,
        'release': version ?? 'release',
        'sdkInt': 1,
        'securityPatch': 'securityPatch',
      },
      'board': 'board',
      'bootloader': 'bootloader',
      'brand': 'brand',
      'device': 'device',
      'display': 'display',
      'fingerprint': 'fingerprint',
      'hardware': 'hardware',
      'host': 'host',
      'id': 'id',
      'manufacturer': 'manufacturer',
      'product': 'product',
      'tags': 'tags',
      'type': 'type',
      'isPhysicalDevice': false,
      'serialNumber': 'serialNumber',
      'isLowRamDevice': false,
      'displayMetrics': <String, double>{
        'widthPx': 0.0,
        'heightPx': 0.0,
        'xDpi': 0.0,
        'yDpi': 0.0,
      },
    });

IosDeviceInfo mockIosDeviceInfo({
  String? phoneModel,
  String? os,
  String? version,
}) =>
    IosDeviceInfo.fromMap(<String, dynamic>{
      'data': <String, dynamic>{},
      'name': 'name',
      'systemName': os ?? 'systemName',
      'systemVersion': version ?? 'systemVersion',
      'model': phoneModel ?? 'model',
      'localizedModel': 'localizedModel',
      'isPhysicalDevice': false,
      'utsname': <String, dynamic>{
        'sysname': 'sysname',
        'nodename': 'nodename',
        'release': 'release',
        'version': 'version',
        'machine': 'machine',
      },
    });

User get mockUser => UserDTO(
      uid: 1,
      email: 'exampe@email.com',
      firstName: 'test',
      lastName: 'test',
      gender: 'Male',
      contactNumber: '123456789',
      birthday: DateTime(2000),
    ).toDomain();

List<Post> get mockPosts => List<Post>.generate(2, (_) => mockPost);

chopper.ChopperClient get mockChopperClient => ChopperConfig().client;

Map<AppScrollController, ScrollController> mockScrollControllers =
    <AppScrollController, ScrollController>{
  AppScrollController.home: ScrollController(),
  AppScrollController.profile: ScrollController(),
};

Post get mockPost => PostDTO(
      uid: '1',
      title: 'Turpis in eu mi bibendum neque egestas congue.',
      author: 'Tempus egestas',
      permalink: '/r/FlutterDev/comments/123456/',
      selftext:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      createdUtc: DateTime.fromMillisecondsSinceEpoch(1672689610000),
      linkFlairBackgroundColor: '#7b35f0',
      linkFlairText: 'Lorem',
      upvotes: 10,
      comments: 2,
    ).toDomain();

chopper.Response<T> generateMockResponse<T>(T body, int statusCode) =>
    chopper.Response<T>(http.Response(json.encode(body), statusCode), body);

extension FileNameX on String {
  String get goldensVersion => '${this}_${TestConfig.goldensVersion}';
}
