import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';

abstract interface class IDeviceInfoRepository {
  Future<Either<Failure, String>> getPhoneModel();

  Future<Either<Failure, (String, String)>> getPhoneOSVersion();

  Either<Failure, String> getAppVersion();

  Either<Failure, String> getBuildNumber();
}
