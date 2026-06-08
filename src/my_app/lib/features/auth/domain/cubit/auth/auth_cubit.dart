import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/core/domain/interface/i_user_repository.dart';
import 'package:very_good_core/features/auth/domain/interface/i_auth_repository.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._userRepository, this._authRepository, this._localStorageRepository, this._failureHandler)
    : super(const AuthState.initial());

  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;
  final ILocalStorageRepository _localStorageRepository;
  final FailureHandler _failureHandler;

  Future<void> initialize() async {
    await safeRun(
      action: () async {
        safeEmit(const AuthState.initial());
        final Result<String?> possibleFailure = await _localStorageRepository.getAccessToken();
        await possibleFailure.fold((Failure failure) async => _failureHandler.handleFailure(failure), (
          String? accessToken,
        ) async {
          if (accessToken == null) {
            safeEmit(const AuthState.unauthenticated());
          } else {
            _emitAuthState(await _userRepository.user, isLogout: true);
          }
        });
      },
      onError: (Exception error) => _emitError(right(error)),
    );
  }

  Future<void> getUser() async {
    await safeRun(
      action: () async {
        safeEmit(const AuthState.loading());
        _emitAuthState(await _userRepository.user);
      },
      onError: (Exception error) => _emitError(right(error), isLogout: false),
    );
  }

  Future<void> authenticate() async {
    await safeRun(
      action: () async {
        safeEmit(const AuthState.loading());
        _emitAuthState(await _userRepository.user, isLogout: true);
      },
      onError: (Exception error) => _emitError(right(error)),
    );
  }

  Future<void> logout() async {
    await safeRun(
      action: () async {
        safeEmit(const AuthState.loading());
        final Result<Unit> possibleFailure = await _authRepository.logout();
        possibleFailure.fold(
          (Failure failure) => _emitError(left(failure)),
          (_) => safeEmit(const AuthState.unauthenticated()),
        );
      },
      onError: (Exception error) => _emitError(right(error)),
    );
  }

  void _emitAuthState(Result<User> possibleFailure, {bool isLogout = false}) {
    possibleFailure.fold((Failure failure) {
      _emitError(left(failure), isLogout: isLogout);
    }, (User user) => safeEmit(AuthState.authenticated(user: user)));
  }

  void _emitError(Result<Object> failureOrError, {bool isLogout = true}) {
    if (isLogout) {
      safeEmit(const AuthState.unauthenticated());
    }
    _failureHandler.handleFailure(
      failureOrError.fold((Failure failure) => failure, (Object error) => Failure.unexpected(error.toString())),
    );
  }
}
