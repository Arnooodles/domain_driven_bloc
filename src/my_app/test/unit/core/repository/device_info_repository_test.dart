import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/core/data/repository/device_info_repository.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/test_utils.dart';

void main() {
  late MockPackageInfo packageInfo;
  late MockDeviceInfoPlugin deviceInfo;
  late DeviceInfoRepository deviceRepository;

  setUp(() {
    packageInfo = MockPackageInfo();
    deviceInfo = MockDeviceInfoPlugin();
    deviceRepository = DeviceInfoRepository(packageInfo, deviceInfo);
  });

  tearDown(() {
    reset(packageInfo);
    reset(deviceInfo);
  });

  group('getAppVersion', () {
    test('should return the package version', () async {
      const String version = '1.0.0';
      when(packageInfo.version).thenReturn(version);

      final Either<Failure, String> result = deviceRepository.getAppVersion();
      expect(result, isA<Right<Failure, String>>());
      expect(result.asRight(), version);
    });

    test('should return DeviceInfoError when exception occurs', () async {
      when(packageInfo.version).thenThrow(Exception('Package info error'));

      final Either<Failure, String> result = deviceRepository.getAppVersion();
      expect(result, isA<Left<Failure, String>>());
      expect(result.asLeft(), isA<DeviceInfoError>());
      expect(result.asLeft().error, 'Exception: Package info error');
    });
  });

  group('getBuildNumber', () {
    test('should return the build number', () async {
      const String buildNumber = '123';
      when(packageInfo.buildNumber).thenReturn(buildNumber);

      final Either<Failure, String> result = deviceRepository.getBuildNumber();
      expect(result, isA<Right<Failure, String>>());
      expect(result.asRight(), buildNumber);
    });

    test('should return DeviceInfoError when exception occurs', () async {
      when(packageInfo.buildNumber).thenThrow(Exception('Build number error'));

      final Either<Failure, String> result = deviceRepository.getBuildNumber();
      expect(result, isA<Left<Failure, String>>());
      expect(result.asLeft(), isA<DeviceInfoError>());
      expect(result.asLeft().error, 'Exception: Build number error');
    });
  });

  group('getPhoneModel', () {
    test('should return the phone model of android devices', () async {
      const String phoneModel = 'pixel 7';

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(
        deviceInfo.androidInfo,
      ).thenAnswer((_) => Future<AndroidDeviceInfo>.value(mockAndroidDeviceInfo(phoneModel: phoneModel)));

      final Either<Failure, String> result = await deviceRepository.getPhoneModel();
      expect(result, isA<Right<Failure, String>>());
      expect(result.asRight(), phoneModel);
    });

    test('should return the phone model of ios devices', () async {
      const String phoneModel = 'iPhone';

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      when(
        deviceInfo.iosInfo,
      ).thenAnswer((_) => Future<IosDeviceInfo>.value(mockIosDeviceInfo(phoneModel: phoneModel)));

      final Either<Failure, String> result = await deviceRepository.getPhoneModel();
      expect(result, isA<Right<Failure, String>>());
      expect(result.asRight(), phoneModel);
    });

    test('should return DeviceInfoError when platform is not android or ios', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      final Either<Failure, String> result = await deviceRepository.getPhoneModel();
      expect(result, isA<Right<Failure, String>>());
      expect(result.asRight(), DeviceInfoRepository.unknown);
    });

    test('should return DeviceInfoError when android device info throws exception', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(deviceInfo.androidInfo).thenThrow(Exception('Android device info error'));

      final Either<Failure, String> result = await deviceRepository.getPhoneModel();
      expect(result, isA<Left<Failure, String>>());
      expect(result.asLeft(), isA<DeviceInfoError>());
      expect(result.asLeft().error, 'Exception: Android device info error');
    });

    test('should return DeviceInfoError when ios device info throws exception', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      when(deviceInfo.iosInfo).thenThrow(Exception('iOS device info error'));

      final Either<Failure, String> result = await deviceRepository.getPhoneModel();
      expect(result, isA<Left<Failure, String>>());
      expect(result.asLeft(), isA<DeviceInfoError>());
      expect(result.asLeft().error, 'Exception: iOS device info error');
    });
  });

  group('getPhoneOSVersion', () {
    test('should return os and version of the ios phone', () async {
      const String os = 'iOS';
      const String version = '1.0';

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      when(
        deviceInfo.iosInfo,
      ).thenAnswer((_) => Future<IosDeviceInfo>.value(mockIosDeviceInfo(os: os, version: version)));

      final Either<Failure, (String, String)> result = await deviceRepository.getPhoneOSVersion();
      expect(result, isA<Right<Failure, (String, String)>>());
      expect(result.asRight(), (os, version));
    });

    test('should return os and version of the android phone', () async {
      const String version = '1.0';

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(
        deviceInfo.androidInfo,
      ).thenAnswer((_) => Future<AndroidDeviceInfo>.value(mockAndroidDeviceInfo(version: version)));

      final Either<Failure, (String, String)> result = await deviceRepository.getPhoneOSVersion();
      expect(result, isA<Right<Failure, (String, String)>>());
      expect(result.asRight(), ('Android', version));
    });

    test('should return DeviceInfoError when platform is not android or ios', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      final Either<Failure, (String, String)> result = await deviceRepository.getPhoneOSVersion();
      expect(result, isA<Right<Failure, (String, String)>>());
      expect(result.asRight(), (DeviceInfoRepository.unknown, DeviceInfoRepository.unknown));
    });

    test('should return DeviceInfoError when android device info throws exception', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(deviceInfo.androidInfo).thenThrow(Exception('Android OS version error'));

      final Either<Failure, (String, String)> result = await deviceRepository.getPhoneOSVersion();
      expect(result, isA<Left<Failure, (String, String)>>());
      expect(result.asLeft(), isA<DeviceInfoError>());
      expect(result.asLeft().error, 'Exception: Android OS version error');
    });

    test('should return DeviceInfoError when ios device info throws exception', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      when(deviceInfo.iosInfo).thenThrow(Exception('iOS OS version error'));

      final Either<Failure, (String, String)> result = await deviceRepository.getPhoneOSVersion();
      expect(result, isA<Left<Failure, (String, String)>>());
      expect(result.asLeft(), isA<DeviceInfoError>());
      expect(result.asLeft().error, 'Exception: iOS OS version error');
    });
  });
}
