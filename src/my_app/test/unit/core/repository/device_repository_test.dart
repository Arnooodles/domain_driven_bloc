import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/data/repository/device_repository.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/test_utils.dart';

void main() {
  late MockPackageInfo packageInfo;
  late MockDeviceInfoPlugin deviceInfo;
  late DeviceRepository deviceRepository;

  setUp(() {
    packageInfo = MockPackageInfo();
    deviceInfo = MockDeviceInfoPlugin();
    deviceRepository = DeviceRepository(packageInfo, deviceInfo);
  });

  tearDown(() {
    reset(packageInfo);
    reset(deviceInfo);
  });

  test(
    ' getAppVersion should return the package version',
    () async {
      const String version = '1.0.0';
      when(
        packageInfo.version,
      ).thenReturn(version);

      expect(deviceRepository.getAppVersion(), version);
    },
  );

  test(
    ' getBuildNumber should return the build number',
    () async {
      const String buildNumber = '123';
      when(
        packageInfo.buildNumber,
      ).thenReturn(buildNumber);

      expect(deviceRepository.getBuildNumber(), buildNumber);
    },
  );

  test(
    ' getPhoneModel should return the phone model of android devices',
    () async {
      const String phoneModel = 'pixel 7';

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(deviceInfo.androidInfo).thenAnswer(
        (_) => Future<AndroidDeviceInfo>.value(
          mockAndroidDeviceInfo(phoneModel: phoneModel),
        ),
      );

      expect(await deviceRepository.getPhoneModel(), phoneModel);
    },
  );
  test(
    ' getPhoneModel should return the phone model of ios devices',
    () async {
      const String phoneModel = 'iPhone';

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      when(deviceInfo.iosInfo).thenAnswer(
        (_) => Future<IosDeviceInfo>.value(
          mockIosDeviceInfo(phoneModel: phoneModel),
        ),
      );

      expect(await deviceRepository.getPhoneModel(), phoneModel);
    },
  );

  test(
    ' getPhoneOSVersion should return os and version of the ios phone',
    () async {
      const String os = 'iOS';
      const String version = '1.0';

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      when(deviceInfo.iosInfo).thenAnswer(
        (_) => Future<IosDeviceInfo>.value(
          mockIosDeviceInfo(os: os, version: version),
        ),
      );

      expect(await deviceRepository.getPhoneOSVersion(), (os, version));
    },
  );

  test(
    ' getPhoneOSVersion should return os and version of the android phone',
    () async {
      const String version = '1.0';

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(deviceInfo.androidInfo).thenAnswer(
        (_) => Future<AndroidDeviceInfo>.value(
          mockAndroidDeviceInfo(version: version),
        ),
      );

      expect(await deviceRepository.getPhoneOSVersion(), ('Android', version));
    },
  );
}
