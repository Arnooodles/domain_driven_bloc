import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

final class _Keys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String emailAddress = 'email_address';
  static const String isDarkMode = 'is_dark_mode';
}

@LazySingleton(as: ILocalStorageRepository)
class LocalStorageRepository implements ILocalStorageRepository {
  const LocalStorageRepository(this._securedStorage, this._unsecuredStorage, this._talker);

  final FlutterSecureStorage _securedStorage;
  final SharedPreferences _unsecuredStorage;
  final Talker _talker;

  /// Secured Storage services
  @override
  TaskResult<String?> getAccessToken() => TaskResult<String?>.tryCatch(
    () => _securedStorage.read(key: _Keys.accessToken),
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<Unit> setAccessToken(String value) => TaskResult<Unit>.tryCatch(
    () async {
      if (value.isNotEmpty) {
        await _securedStorage.write(key: _Keys.accessToken, value: value);
      }
      return unit;
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<Unit> deleteAccessToken() => TaskResult<Unit>.tryCatch(
    () async {
      await _securedStorage.delete(key: _Keys.accessToken);
      return unit;
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<String?> getRefreshToken() => TaskResult<String?>.tryCatch(
    () => _securedStorage.read(key: _Keys.refreshToken),
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<Unit> setRefreshToken(String value) => TaskResult<Unit>.tryCatch(
    () async {
      if (value.isNotEmpty) {
        await _securedStorage.write(key: _Keys.refreshToken, value: value);
      }
      return unit;
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<Unit> deleteRefreshToken() => TaskResult<Unit>.tryCatch(
    () async {
      await _securedStorage.delete(key: _Keys.refreshToken);
      return unit;
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  /// Unsecured storage services
  @override
  TaskResult<String?> getLastLoggedInUsername() => TaskResult<String?>.tryCatch(
    () async => _unsecuredStorage.getString(_Keys.emailAddress),
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<Unit> setLastLoggedInUsername(String value) => TaskResult<Unit>.tryCatch(
    () async {
      if (value.isNotEmpty) {
        await _unsecuredStorage.setString(_Keys.emailAddress, value);
      }
      return unit;
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<bool?> getIsDarkMode() => TaskResult<bool?>.tryCatch(
    () async => _unsecuredStorage.getBool(_Keys.isDarkMode),
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );

  @override
  TaskResult<Unit> setIsDarkMode({required bool isDarkMode}) => TaskResult<Unit>.tryCatch(
    () async {
      await _unsecuredStorage.setBool(_Keys.isDarkMode, isDarkMode);
      return unit;
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      return Failure.deviceStorage(error.toString());
    },
  );
}
