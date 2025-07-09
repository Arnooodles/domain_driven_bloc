import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/core/domain/interface/i_user_repository.dart';
import 'package:very_good_core/features/auth/domain/interface/i_auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this._userRepository, this._authRepository, this._localStorageRepository) : super(const AuthState.initial());

  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;
  final ILocalStorageRepository _localStorageRepository;

  Future<void> initialize() async {
    try {
      safeEmit(const AuthState.initial());
      if (await _localStorageRepository.getAccessToken() == null) {
        safeEmit(const AuthState.unauthenticated());
      } else {
        _emitAuthState(await _userRepository.user, isLogout: true);
      }
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
      safeEmit(possibleFailure.fold(AuthState.onFailure, (_) => const AuthState.unauthenticated()));
    } on Exception catch (error) {
      _emitError(error);
    }
  }

  void _emitAuthState(Either<Failure, User> possibleFailure, {bool isLogout = false}) {
    possibleFailure.fold((Failure failure) {
      safeEmit(AuthState.onFailure(failure));
      if (isLogout) {
        safeEmit(const AuthState.unauthenticated());
      }
    }, (User user) => safeEmit(AuthState.authenticated(user: user)));
  }

  void _emitError(Object error) {
    log(error.toString());
    safeEmit(AuthState.onFailure(Failure.unexpected(error.toString())));
  }
}
