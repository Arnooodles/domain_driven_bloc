import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';

abstract interface class IDeviceInfoRepository {
  Future<Result<String>> getPhoneModel();

  Future<Result<(String, String)>> getPhoneOSVersion();

  Result<String> getAppVersion();

  Result<String> getBuildNumber();
}
