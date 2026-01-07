import 'package:very_good_core/core/domain/entity/typedef.dart';

abstract interface class IDeviceInfoRepository {
  Future<Result<String>> getPhoneModel();

  Future<Result<(String, String)>> getPhoneOSVersion();

  Result<String> getAppVersion();

  Result<String> getBuildNumber();
}
