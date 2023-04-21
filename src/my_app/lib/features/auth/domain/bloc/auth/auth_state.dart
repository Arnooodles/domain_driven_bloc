part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({
    required User user,
  }) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;

  const factory AuthState.failed(Failure failure) = AuthFailure;

  const AuthState._();
}
