import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';

abstract interface class ILocalStorageRepository {
  Future<Either<Failure, String?>> getAccessToken();
  Future<Either<Failure, Unit>> setAccessToken(String accessToken);
  Future<Either<Failure, Unit>> deleteAccessToken();

  Future<Either<Failure, String?>> getRefreshToken();
  Future<Either<Failure, Unit>> setRefreshToken(String refreshToken);
  Future<Either<Failure, Unit>> deleteRefreshToken();

  Future<Either<Failure, String?>> getLastLoggedInUsername();
  Future<Either<Failure, Unit>> setLastLoggedInUsername(String username);

  Future<Either<Failure, bool?>> getIsDarkMode();
  Future<Either<Failure, Unit>> setIsDarkMode({required bool isDarkMode});
}
