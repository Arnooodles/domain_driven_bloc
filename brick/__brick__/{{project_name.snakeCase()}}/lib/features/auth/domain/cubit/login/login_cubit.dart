import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/fpdart_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/failure_handler.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> with BlocPresentationMixin<LoginState, LoginPresentationEvent> {
  LoginCubit(this._authRepository, this._localStorageRepository, this._failureHandler) : super(LoginState.initial());

  final IAuthRepository _authRepository;
  final ILocalStorageRepository _localStorageRepository;
  final FailureHandler _failureHandler;

  Future<void> initialize() async {
    try {
      final Result<String?> possibleFailure = await _localStorageRepository.getLastLoggedInUsername();
      possibleFailure.fold(_failureHandler.handleFailure, (String? username) {
        safeEmit(state.copyWith(username: username));
      });
    } on Exception catch (error) {
      _failureHandler.handleFailure(Failure.unexpected(error.toString()));
    } finally {
      safeEmit(state.copyWith(isLoading: false));
    }
  }

  Future<void> login(String username, String password) async {
    try {
      safeEmit(state.copyWith(isLoading: true, username: username));

      final Password validPassword = Password(password);
      final ValueString validUsername = ValueString(username, fieldName: 'username');

      if (validUsername.isValid && validPassword.isValid) {
        final Result<Unit> possibleFailure = await _authRepository.login(
          LoginRequest(username: validUsername, password: validPassword),
        );

        possibleFailure.fold(_emitFailure, (_) {
          safeEmit(state.copyWith(isLoading: false));
          emitPresentation(const LoginPresentationEvent.onSuccess());
        });
      } else {
        _emitFailure(!validUsername.isValid ? validUsername.value.asLeft() : validPassword.value.asLeft());
      }
    } on Exception catch (error) {
      log(error.toString());
      _emitFailure(Failure.unexpected(error.toString()));
    }
  }

  void _emitFailure(Failure failure) {
    safeEmit(state.copyWith(isLoading: false));
    _failureHandler.handleFailure(failure);
  }

  void onUsernameChanged(String username) => safeEmit(state.copyWith(username: username, isLoading: false));
}
