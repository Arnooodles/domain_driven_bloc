import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';

final class _Keys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String emailAddress = 'email_address';
}

@LazySingleton(as: ILocalStorageRepository)
class LocalStorageRepository implements ILocalStorageRepository {
  const LocalStorageRepository(
    this._securedStorage,
    this._unsecuredStorage,
  );

  final FlutterSecureStorage _securedStorage;
  final SharedPreferences _unsecuredStorage;

  Logger get _logger => getIt<Logger>();

  /// Secured Storage services
  @override
  Future<String?> getAccessToken() =>
      _securedStorage.read(key: _Keys.accessToken);
  @override
  Future<void> setAccessToken(String? value) async {
    try {
      await _securedStorage.write(key: _Keys.accessToken, value: value);
    } catch (error) {
      _logger.e(error.toString());
      throw Exception(error);
    }
  }

  @override
  Future<String?> getRefreshToken() =>
      _securedStorage.read(key: _Keys.refreshToken);
  @override
  Future<void> setRefreshToken(String? value) async {
    try {
      await _securedStorage.write(key: _Keys.refreshToken, value: value);
    } catch (error) {
      _logger.e(error.toString());
      throw Exception(error);
    }
  }

  /// Unsecured storage services
  @override
  Future<String?> getLastLoggedInEmail() async =>
      _unsecuredStorage.getString(_Keys.emailAddress);
  @override
  Future<void> setLastLoggedInEmail(String? value) async {
    try {
      await _unsecuredStorage.setString(_Keys.emailAddress, value ?? '');
    } catch (error) {
      _logger.e(error.toString());
      throw Exception(error);
    }
  }
}
