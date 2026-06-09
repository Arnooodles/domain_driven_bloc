import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker/talker.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_device_info_repository.dart';

@LazySingleton(as: IDeviceInfoRepository)
class DeviceInfoRepository implements IDeviceInfoRepository {
  const DeviceInfoRepository(this._packageInfo, this._deviceInfo, this._talker);

  final PackageInfo _packageInfo;
  final DeviceInfoPlugin _deviceInfo;
  final Talker _talker;

  static const String unknown = 'Unknown';
  static const String android = 'Android';

  @override
  Result<String> getAppVersion() {
    try {
      return right(_packageInfo.version);
    } on Exception catch (error, stackTrace) {
      _talker.handle(error, stackTrace);
      return left(Failure.deviceInfo(error.toString()));
    }
  }

  @override
  Result<String> getBuildNumber() {
    try {
      return right(_packageInfo.buildNumber);
    } on Exception catch (error, stackTrace) {
      _talker.handle(error, stackTrace);
      return left(Failure.deviceInfo(error.toString()));
    }
  }

  @override
  TaskResult<String> getPhoneModel() => TaskResult<String>.tryCatch(
    () async {
      if (defaultTargetPlatform case TargetPlatform.android) {
        return (await _deviceInfo.androidInfo).model;
      } else if (defaultTargetPlatform case TargetPlatform.iOS) {
        return (await _deviceInfo.iosInfo).model;
      } else {
        return unknown;
      }
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceInfo(error.toString());
    },
  );

  /// Returns(OS, Version)
  @override
  TaskResult<(String, String)> getPhoneOSVersion() => TaskResult<(String, String)>.tryCatch(
    () async {
      if (defaultTargetPlatform case TargetPlatform.android) {
        return (android, (await _deviceInfo.androidInfo).version.release);
      } else if (defaultTargetPlatform case TargetPlatform.iOS) {
        final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        return (iosInfo.systemName, iosInfo.systemVersion);
      } else {
        return (unknown, unknown);
      }
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceInfo(error.toString());
    },
  );
}
