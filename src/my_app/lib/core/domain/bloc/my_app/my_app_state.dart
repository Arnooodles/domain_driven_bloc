part of 'my_app_bloc.dart';

@freezed
class MyAppState with _$MyAppState {
  factory MyAppState({
    required AuthStatus authStatus,
    required ThemeMode themeMode,
    required bool isLoading,
    Failure? failure,
    User? user,
  }) = _MyAppState;

  factory MyAppState.initial() => _MyAppState(
        authStatus: AuthStatus.unknown,
        themeMode: ThemeMode.system,
        isLoading: false,
      );
}
