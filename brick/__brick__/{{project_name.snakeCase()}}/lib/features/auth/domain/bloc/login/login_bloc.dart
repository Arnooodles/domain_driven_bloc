import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/either_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

part 'login_bloc.freezed.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Cubit<LoginState> {
  LoginBloc(
    this._authRepository,
    this._localStorageRepository,
  ) : super(LoginState.initial()) {
    initialize();
  }

  final IAuthRepository _authRepository;
  final ILocalStorageRepository _localStorageRepository;

  Future<void> initialize() async {
    final String? email = await _localStorageRepository.getLastLoggedInEmail();
    safeEmit(state.copyWith(emailAddress: email, isLoading: false));
  }

  Future<void> login(String email, String password) async {
    try {
      safeEmit(state.copyWith(isLoading: true, emailAddress: email));
      final EmailAddress validEmail = EmailAddress(email);
      final Password validPassword = Password(password);

      if (validEmail.isValid() && validPassword.isValid()) {
        final Either<Failure, Unit> possibleFailure =
            await _authRepository.login(validEmail, validPassword);

        possibleFailure.fold(
          _emitFailure,
          (_) => safeEmit(
            state.copyWith(
              isLoading: false,
              loginStatus: const LoginStatus.success(),
            ),
          ),
        );
      } else {
        _emitFailure(
          !validEmail.isValid()
              ? validEmail.value.asLeft()
              : validPassword.value.asLeft(),
        );
      }
    } on Exception catch (error) {
      log(error.toString());
      _emitFailure(Failure.unexpected(error.toString()));
    }
  }

  void _emitFailure(Failure failure) {
    safeEmit(
      state.copyWith(
        isLoading: false,
        loginStatus: LoginStatus.failed(failure),
      ),
    );
    // Reset Failed Login Status to Initial State
    safeEmit(state.copyWith(loginStatus: const LoginStatus.initial()));
  }

  void onEmailAddressChanged(String emailAddress) =>
      safeEmit(state.copyWith(emailAddress: emailAddress));
}
