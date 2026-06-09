import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/failure_handler.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

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
        final Result<String?> possibleFailure = await _localStorageRepository.getAccessToken().run();
        await possibleFailure.fold((Failure failure) async => _failureHandler.handleFailure(failure), (
          String? accessToken,
        ) async {
          if (accessToken == null) {
            safeEmit(const AuthState.unauthenticated());
          } else {
            _emitAuthState(await _userRepository.user.run(), isLogout: true);
          }
        });
      },
      onException: (Exception error, StackTrace? stackTrace) => _emitError(right(error), stackTrace: stackTrace),
    );
  }

  Future<void> getUser() async {
    await safeRun(
      action: () async {
        safeEmit(const AuthState.loading());
        _emitAuthState(await _userRepository.user.run());
      },
      onException: (Exception error, StackTrace? stackTrace) =>
          _emitError(right(error), isLogout: false, stackTrace: stackTrace),
    );
  }

  Future<void> authenticate() async {
    await safeRun(
      action: () async {
        safeEmit(const AuthState.loading());
        _emitAuthState(await _userRepository.user.run(), isLogout: true);
      },
      onException: (Exception error, StackTrace? stackTrace) => _emitError(right(error), stackTrace: stackTrace),
    );
  }

  Future<void> logout() async {
    await safeRun(
      action: () async {
        safeEmit(const AuthState.loading());
        final Result<Unit> possibleFailure = await _authRepository.logout().run();
        possibleFailure.fold(
          (Failure failure) => _emitError(left(failure)),
          (_) => safeEmit(const AuthState.unauthenticated()),
        );
      },
      onException: (Exception error, StackTrace? stackTrace) => _emitError(right(error), stackTrace: stackTrace),
    );
  }

  void _emitAuthState(Result<User> possibleFailure, {bool isLogout = false}) {
    possibleFailure.fold((Failure failure) {
      _emitError(left(failure), isLogout: isLogout);
    }, (User user) => safeEmit(AuthState.authenticated(user: user)));
  }

  void _emitError(Result<Object> failureOrError, {bool isLogout = true, StackTrace? stackTrace}) {
    if (isLogout) {
      safeEmit(const AuthState.unauthenticated());
    }
    failureOrError.fold(_failureHandler.handleFailure, (Object error) {
      _failureHandler.handleException(error as Exception, stackTrace);
    });
  }
}
