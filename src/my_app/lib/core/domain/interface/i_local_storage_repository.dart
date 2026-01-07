import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';

abstract interface class ILocalStorageRepository {
  Future<Result<String?>> getAccessToken();
  Future<Result<Unit>> setAccessToken(String accessToken);
  Future<Result<Unit>> deleteAccessToken();

  Future<Result<String?>> getRefreshToken();
  Future<Result<Unit>> setRefreshToken(String refreshToken);
  Future<Result<Unit>> deleteRefreshToken();

  Future<Result<String?>> getLastLoggedInUsername();
  Future<Result<Unit>> setLastLoggedInUsername(String username);

  Future<Result<bool?>> getIsDarkMode();
  Future<Result<Unit>> setIsDarkMode({required bool isDarkMode});
}
