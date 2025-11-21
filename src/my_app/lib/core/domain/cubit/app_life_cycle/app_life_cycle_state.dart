part of 'app_life_cycle_cubit.dart';

@freezed
sealed class AppLifeCycleState with _$AppLifeCycleState {
  const factory AppLifeCycleState.detached() = _Detached;
  const factory AppLifeCycleState.inactive() = _Inactive;
  const factory AppLifeCycleState.paused() = _Paused;
  const factory AppLifeCycleState.resumed() = _Resumed;
  const factory AppLifeCycleState.hidden() = _Hidden;

  const AppLifeCycleState._();

  factory AppLifeCycleState.initialize(AppLifecycleState? state) => switch (state) {
    AppLifecycleState.detached => const AppLifeCycleState.detached(),
    AppLifecycleState.resumed => const AppLifeCycleState.resumed(),
    AppLifecycleState.inactive => const AppLifeCycleState.inactive(),
    AppLifecycleState.hidden => const AppLifeCycleState.hidden(),
    AppLifecycleState.paused => const AppLifeCycleState.paused(),
    _ => const AppLifeCycleState.resumed(),
  };
}
