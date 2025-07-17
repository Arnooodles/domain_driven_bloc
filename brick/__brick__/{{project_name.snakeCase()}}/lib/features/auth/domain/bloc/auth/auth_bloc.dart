import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/failure_handler.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this._userRepository, this._authRepository, this._localStorageRepository, this._failureHandler)
    : super(const AuthState.initial());

  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;
  final ILocalStorageRepository _localStorageRepository;
  final FailureHandler _failureHandler;

  Future<void> initialize() async {
    try {
      safeEmit(const AuthState.initial());
      final Either<Failure, String?> possibleFailure = await _localStorageRepository.getAccessToken();
      possibleFailure.fold(_failureHandler.handleFailure, (String? accessToken) async {
        if (accessToken == null) {
          safeEmit(const AuthState.unauthenticated());
        } else {
          _emitAuthState(await _userRepository.user, isLogout: true);
        }
      });
    } on Exception catch (error) {
      _emitError(error);
    }
  }

  Future<void> getUser() async {
    try {
      safeEmit(const AuthState.loading());
      _emitAuthState(await _userRepository.user);
    } on Exception catch (error) {
      _emitError(error);
    }
  }

  Future<void> authenticate() async {
    try {
      safeEmit(const AuthState.loading());
      _emitAuthState(await _userRepository.user, isLogout: true);
    } on Exception catch (error) {
      _emitError(error);
    }
  }

  Future<void> logout() async {
    try {
      safeEmit(const AuthState.loading());
      final Either<Failure, Unit> possibleFailure = await _authRepository.logout();
      possibleFailure.fold(_failureHandler.handleFailure, (_) => safeEmit(const AuthState.unauthenticated()));
    } on Exception catch (error) {
      _emitError(error);
    }
  }

  void _emitAuthState(Either<Failure, User> possibleFailure, {bool isLogout = false}) {
    possibleFailure.fold((Failure failure) {
      _failureHandler.handleFailure(failure);

      if (isLogout) {
        safeEmit(const AuthState.unauthenticated());
      }
    }, (User user) => safeEmit(AuthState.authenticated(user: user)));
  }

  void _emitError(Object error) {
    log(error.toString());
    _failureHandler.handleFailure(Failure.unexpected(error.toString()));
  }
}
