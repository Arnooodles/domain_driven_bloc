part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    required bool isLoading,
    required bool isLogout,
    Failure? failure,
    User? user,
  }) = _AuthState;

  factory AuthState.initial() => const _AuthState(
        status: AuthStatus.unknown,
        isLoading: false,
        isLogout: false,
      );
}
