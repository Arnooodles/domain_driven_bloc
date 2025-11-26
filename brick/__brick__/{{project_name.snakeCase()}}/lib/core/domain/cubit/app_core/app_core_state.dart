part of 'app_core_cubit.dart';

@freezed
sealed class AppCoreState with _$AppCoreState {
  const factory AppCoreState() = _AppCoreState;

  factory AppCoreState.initial() => const _AppCoreState();
}
