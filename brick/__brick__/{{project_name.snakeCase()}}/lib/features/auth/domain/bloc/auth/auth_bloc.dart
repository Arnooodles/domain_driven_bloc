import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/failures.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/user.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Cubit<AuthState> {
  AuthBloc(
    this._userRepository,
    this._authRepository,
  ) : super(AuthState.initial()) {
    initialize();
  }

  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;

  Future<void> initialize() async {
    await checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      emit(state.copyWith(isLoading: true, failure: null));
      final Option<User> user = await _userRepository.user;
      emit(
        user.fold(
          () => state.copyWith(
            status: AuthStatus.unauthenticated,
            isLoading: false,
          ),
          (User user) => state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            isLoading: false,
          ),
        ),
      );
    } catch (error) {
      log(error.toString());
      emit(
        state.copyWith(
          failure: Failure.unexpected(error.toString()),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> getUser() async {
    try {
      emit(state.copyWith(isLoading: true, failure: null));
      final Option<User> user = await _userRepository.user;

      emit(
        user.fold(
          () => state.copyWith(
            user: null,
            status: AuthStatus.unauthenticated,
            isLoading: false,
          ),
          (User user) => state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            isLoading: false,
          ),
        ),
      );
    } catch (error) {
      log(error.toString());
      emit(
        state.copyWith(
          failure: Failure.unexpected(error.toString()),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(isLogout: true, failure: null));
      final Either<Failure, Unit> possibleFailure =
          await _authRepository.logout();

      emit(
        possibleFailure.fold(
          (Failure failure) => state.copyWith(
            failure: failure,
            isLogout: false,
          ),
          (_) => state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
            isLogout: false,
          ),
        ),
      );
    } catch (error) {
      log(error.toString());
      emit(
        state.copyWith(
          failure: Failure.unexpected(error.toString()),
          isLogout: false,
        ),
      );
    }
  }

  Future<void> authenticate() async {
    try {
      emit(state.copyWith(isLoading: true, failure: null));
      final Option<User> user = await _userRepository.user;
      user.fold(
        () => emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
            isLoading: false,
          ),
        ),
        (User user) async => emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            isLoading: false,
          ),
        ),
      );
    } catch (error) {
      log(error.toString());
      emit(
        state.copyWith(
          failure: Failure.unexpected(error.toString()),
          isLoading: false,
        ),
      );
    }
  }
}
