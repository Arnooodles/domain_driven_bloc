import 'package:very_good_core/core/domain/entity/typedef.dart';

abstract interface class IDeviceInfoRepository {
  TaskResult<String> getPhoneModel();

  TaskResult<(String, String)> getPhoneOSVersion();

  Result<String> getAppVersion();

  Result<String> getBuildNumber();
}
