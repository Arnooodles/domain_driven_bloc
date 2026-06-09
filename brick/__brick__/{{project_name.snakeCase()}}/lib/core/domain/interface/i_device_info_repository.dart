import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';

abstract interface class IDeviceInfoRepository {
  TaskResult<String> getPhoneModel();

  TaskResult<(String, String)> getPhoneOSVersion();

  Result<String> getAppVersion();

  Result<String> getBuildNumber();
}
