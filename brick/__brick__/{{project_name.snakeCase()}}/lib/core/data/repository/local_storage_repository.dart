import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

final class _Keys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String emailAddress = 'email_address';
  static const String isDarkMode = 'is_dark_mode';
}

@LazySingleton(as: ILocalStorageRepository)
class LocalStorageRepository implements ILocalStorageRepository {
  const LocalStorageRepository(this._securedStorage, this._unsecuredStorage);

  final FlutterSecureStorage _securedStorage;
  final SharedPreferences _unsecuredStorage;

  Logger get _logger => getIt<Logger>();

  /// Secured Storage services
  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      return right(await _securedStorage.read(key: _Keys.accessToken));
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setAccessToken(String value) async {
    try {
      if (value.isNotEmpty) {
        await _securedStorage.write(key: _Keys.accessToken, value: value);
      }

      return right(unit);
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccessToken() async {
    try {
      await _securedStorage.delete(key: _Keys.accessToken);
      return right(unit);
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getRefreshToken() async {
    try {
      return right(await _securedStorage.read(key: _Keys.refreshToken));
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setRefreshToken(String value) async {
    try {
      if (value.isNotEmpty) {
        await _securedStorage.write(key: _Keys.refreshToken, value: value);
      }
      return right(unit);
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRefreshToken() async {
    try {
      await _securedStorage.delete(key: _Keys.refreshToken);
      return right(unit);
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  /// Unsecured storage services
  @override
  Future<Either<Failure, String?>> getLastLoggedInUsername() async {
    try {
      return right(_unsecuredStorage.getString(_Keys.emailAddress));
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setLastLoggedInUsername(String value) async {
    try {
      if (value.isNotEmpty) {
        await _unsecuredStorage.setString(_Keys.emailAddress, value);
      }
      return right(unit);
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, bool?>> getIsDarkMode() async {
    try {
      return right(_unsecuredStorage.getBool(_Keys.isDarkMode));
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setIsDarkMode({required bool isDarkMode}) async {
    try {
      await _unsecuredStorage.setBool(_Keys.isDarkMode, isDarkMode);
      return right(unit);
    } on Exception catch (error) {
      _logger.e(error.toString());
      return left(Failure.deviceStorage(error.toString()));
    }
  }
}
