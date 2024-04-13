part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({
    required User user,
  }) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;

  const factory AuthState.failed(Failure failure) = _AuthFailure;

  const AuthState._();
}
