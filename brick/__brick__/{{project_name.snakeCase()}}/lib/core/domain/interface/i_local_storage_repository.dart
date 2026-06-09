import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';

abstract interface class ILocalStorageRepository {
  TaskResult<String?> getAccessToken();
  TaskResult<Unit> setAccessToken(String accessToken);
  TaskResult<Unit> deleteAccessToken();

  TaskResult<String?> getRefreshToken();
  TaskResult<Unit> setRefreshToken(String refreshToken);
  TaskResult<Unit> deleteRefreshToken();

  TaskResult<String?> getLastLoggedInUsername();
  TaskResult<Unit> setLastLoggedInUsername(String username);

  TaskResult<bool?> getIsDarkMode();
  TaskResult<Unit> setIsDarkMode({required bool isDarkMode});
}
