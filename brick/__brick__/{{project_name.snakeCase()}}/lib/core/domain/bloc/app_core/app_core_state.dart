part of 'app_core_bloc.dart';

@freezed
class AppCoreState with _$AppCoreState {
  const factory AppCoreState({
    required Map<AppScrollController, ScrollController> scrollControllers,
  }) = _AppCoreState;

  factory AppCoreState.initial() => const _AppCoreState(
        scrollControllers: <AppScrollController, ScrollController>{},
      );
}
