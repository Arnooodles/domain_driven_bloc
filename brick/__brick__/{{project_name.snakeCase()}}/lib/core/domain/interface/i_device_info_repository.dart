import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';

abstract interface class IDeviceInfoRepository {
  Future<Either<Failure, String>> getPhoneModel();

  Future<Either<Failure, (String, String)>> getPhoneOSVersion();

  Either<Failure, String> getAppVersion();

  Either<Failure, String> getBuildNumber();
}
