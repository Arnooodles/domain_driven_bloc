import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/interface/i_device_info_repository.dart';

@LazySingleton(as: IDeviceInfoRepository)
class DeviceInfoRepository implements IDeviceInfoRepository {
  const DeviceInfoRepository(this._packageInfo, this._deviceInfo);

  final PackageInfo _packageInfo;
  final DeviceInfoPlugin _deviceInfo;

  static const String unknown = 'Unknown';
  static const String android = 'Android';

  @override
  Either<Failure, String> getAppVersion() {
    try {
      return right(_packageInfo.version);
    } on Exception catch (error) {
      return left(Failure.deviceInfo(error.toString()));
    }
  }

  @override
  Either<Failure, String> getBuildNumber() {
    try {
      return right(_packageInfo.buildNumber);
    } on Exception catch (error) {
      return left(Failure.deviceInfo(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getPhoneModel() async {
    try {
      if (defaultTargetPlatform case TargetPlatform.android) {
        return right((await _deviceInfo.androidInfo).model);
      } else if (defaultTargetPlatform case TargetPlatform.iOS) {
        return right((await _deviceInfo.iosInfo).model);
      } else {
        return right(unknown);
      }
    } on Exception catch (error) {
      return left(Failure.deviceInfo(error.toString()));
    }
  }

  /// Returns(OS, Version)
  @override
  Future<Either<Failure, (String, String)>> getPhoneOSVersion() async {
    try {
      if (defaultTargetPlatform case TargetPlatform.android) {
        return right((android, (await _deviceInfo.androidInfo).version.release));
      } else if (defaultTargetPlatform case TargetPlatform.iOS) {
        final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        return right((iosInfo.systemName, iosInfo.systemVersion));
      } else {
        return right((unknown, unknown));
      }
    } on Exception catch (error) {
      return left(Failure.deviceInfo(error.toString()));
    }
  }
}
