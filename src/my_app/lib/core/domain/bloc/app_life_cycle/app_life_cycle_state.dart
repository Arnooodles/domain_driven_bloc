part of 'app_life_cycle_bloc.dart';

@freezed
class AppLifeCycleState with _$AppLifeCycleState {
  const factory AppLifeCycleState.detached() = AppLifeCycleDetached;
  const factory AppLifeCycleState.inactive() = AppLifeCycleInactive;
  const factory AppLifeCycleState.paused() = AppLifeCyclePaused;
  const factory AppLifeCycleState.resumed() = AppLifeCycleResumed;

  const AppLifeCycleState._();

  bool get isResumed => maybeWhen(resumed: () => true, orElse: () => false);
}
