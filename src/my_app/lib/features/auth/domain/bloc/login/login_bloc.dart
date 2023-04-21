import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/core/domain/model/failure.dart';
import 'package:very_good_core/core/domain/model/value_object.dart';
import 'package:very_good_core/features/auth/domain/interface/i_auth_repository.dart';

part 'login_bloc.freezed.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Cubit<LoginState> {
  LoginBloc(
    this._authRepository,
    this._localStorageRepository,
  ) : super(const LoginState.initial(isLoading: true)) {
    initialize();
  }

  final IAuthRepository _authRepository;
  final ILocalStorageRepository _localStorageRepository;

  Future<void> initialize() async {
    final String? email = await _localStorageRepository.getLastLoggedInEmail();
    safeEmit(LoginState.initial(emailAddress: email, isLoading: false));
  }

  Future<void> login(String email, String password) async {
    try {
      state.mapOrNull(
        initial: (LoginInitial state) =>
            safeEmit(state.copyWith(isLoading: true)),
      );
      final EmailAddress validEmail = EmailAddress(email);
      final Password validPassword = Password(password);

      if (validEmail.isValid() && validPassword.isValid()) {
        final Either<Failure, Unit> possibleFailure =
            await _authRepository.login(validEmail, validPassword);

        possibleFailure.fold(
          (Failure failure) => _emitFailure(
            email: email,
            failure: failure,
          ),
          (_) => safeEmit(const LoginState.success()),
        );
      } else {
        _emitFailure(
          email: email,
          failure: !validEmail.isValid()
              ? validEmail.value.asLeft()
              : validPassword.value.asLeft(),
        );
      }
    } catch (error) {
      log(error.toString());

      _emitFailure(
        email: email,
        failure: Failure.unexpected(error.toString()),
      );
    }
  }

  void _emitFailure({
    required String email,
    required Failure failure,
  }) {
    safeEmit(LoginState.failed(failure));
    safeEmit(
      LoginState.initial(isLoading: false, emailAddress: email),
    );
  }

  void onEmailAddressChanged(String emailAddress) => state.mapOrNull(
        initial: (LoginInitial state) =>
            safeEmit(state.copyWith(emailAddress: emailAddress)),
      );
}
