import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_device_repository.dart';

@LazySingleton(as: IDeviceRepository)
class DeviceRepository implements IDeviceRepository {
  const DeviceRepository(
    this._packageInfo,
    this._deviceInfo,
  );

  final PackageInfo _packageInfo;
  final DeviceInfoPlugin _deviceInfo;

  static const String unknown = 'Unknown';
  static const String android = 'Android';

  @override
  String getAppVersion() => _packageInfo.version;

  @override
  String getBuildNumber() => _packageInfo.buildNumber;

  @override
  Future<String> getPhoneModel() async {
    if (defaultTargetPlatform case TargetPlatform.android) {
      return (await _deviceInfo.androidInfo).model;
    } else if (defaultTargetPlatform case TargetPlatform.iOS) {
      return (await _deviceInfo.iosInfo).model;
    } else {
      return unknown;
    }
  }

  /// Returns(OS, Version)
  @override
  Future<(String, String)> getPhoneOSVersion() async {
    if (defaultTargetPlatform case TargetPlatform.android) {
      return (android, (await _deviceInfo.androidInfo).version.release);
    } else if (defaultTargetPlatform case TargetPlatform.iOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return (iosInfo.systemName, iosInfo.systemVersion);
    } else {
      return (unknown, unknown);
    }
  }
}
