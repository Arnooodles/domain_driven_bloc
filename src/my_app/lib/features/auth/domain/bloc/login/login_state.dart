part of 'login_bloc.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState({required bool isLoading, String? username}) = _LoginState;

  factory LoginState.initial() => const _LoginState(isLoading: true);

  const LoginState._();
}

@freezed
sealed class LoginPresentationEvent with _$LoginPresentationEvent {
  const factory LoginPresentationEvent.onFailure(Failure failure) = _LoginFailedEvent;
  const factory LoginPresentationEvent.onSuccess() = _LoginSuccessEvent;
}
