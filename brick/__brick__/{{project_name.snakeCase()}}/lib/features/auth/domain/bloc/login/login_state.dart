part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required bool isLoading,
    required LoginStatus loginStatus,
    String? emailAddress,
  }) = _LoginState;

  factory LoginState.initial() => const _LoginState(
        isLoading: true,
        loginStatus: LoginStatus.initial(),
      );

  const LoginState._();
}

@freezed
class LoginStatus with _$LoginStatus {
  const factory LoginStatus.initial() = _Initial;
  const factory LoginStatus.success() = _Success;
  const factory LoginStatus.failed(Failure failure) = _Failure;
}
