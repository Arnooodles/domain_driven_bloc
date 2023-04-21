part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial({
    required bool isLoading,
    String? emailAddress,
  }) = LoginInitial;
  const factory LoginState.success() = LoginSuccess;
  const factory LoginState.failed(Failure failure) = LoginFailure;

  const LoginState._();
}
