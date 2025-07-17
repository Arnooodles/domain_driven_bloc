import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/features/auth/domain/entity/login_request.dart';
import 'package:very_good_core/features/auth/domain/interface/i_auth_repository.dart';

part 'login_bloc.freezed.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Cubit<LoginState> with BlocPresentationMixin<LoginState, LoginPresentationEvent> {
  LoginBloc(this._authRepository, this._localStorageRepository, this._failureHandler) : super(LoginState.initial());

  final IAuthRepository _authRepository;
  final ILocalStorageRepository _localStorageRepository;
  final FailureHandler _failureHandler;

  Future<void> initialize() async {
    final Either<Failure, String?> possibleFailure = await _localStorageRepository.getLastLoggedInUsername();
    possibleFailure.fold(_failureHandler.handleFailure, (String? username) {
      safeEmit(state.copyWith(username: username, isLoading: false));
    });
  }

  Future<void> login(String username, String password) async {
    try {
      safeEmit(state.copyWith(isLoading: true, username: username));

      final Password validPassword = Password(password);
      final ValueString validUsername = ValueString(username, fieldName: 'username');

      if (validUsername.isValid && validPassword.isValid) {
        final Either<Failure, Unit> possibleFailure = await _authRepository.login(
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

  void onUsernameChanged(String username) => safeEmit(state.copyWith(username: username));
}
