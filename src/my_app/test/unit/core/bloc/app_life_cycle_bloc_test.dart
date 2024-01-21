import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';

void main() {
  late AppLifeCycleBloc appLifeCycleBloc;

  setUp(() {
    appLifeCycleBloc = AppLifeCycleBloc();
  });

  tearDown(() {
    appLifeCycleBloc.close();
  });

  void setAppLifeCycleState(AppLifecycleState state) =>
      TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(state);

  blocTest<AppLifeCycleBloc, AppLifeCycleState>(
    'should emit a detached lifecycle state',
    build: () => appLifeCycleBloc,
    act: (AppLifeCycleBloc bloc) =>
        setAppLifeCycleState(AppLifecycleState.detached),
    expect: () => <dynamic>[const AppLifeCycleState.detached()],
  );

  blocTest<AppLifeCycleBloc, AppLifeCycleState>(
    'should emit a hidden lifecycle state',
    build: () => appLifeCycleBloc,
    act: (AppLifeCycleBloc bloc) =>
        setAppLifeCycleState(AppLifecycleState.hidden),
    expect: () => <dynamic>[const AppLifeCycleState.hidden()],
  );

  blocTest<AppLifeCycleBloc, AppLifeCycleState>(
    'should emit a paused lifecycle state',
    build: () => appLifeCycleBloc,
    act: (AppLifeCycleBloc bloc) =>
        setAppLifeCycleState(AppLifecycleState.paused),
    expect: () => <dynamic>[const AppLifeCycleState.paused()],
  );

  blocTest<AppLifeCycleBloc, AppLifeCycleState>(
    'should emit a resumed lifecycle state',
    build: () => appLifeCycleBloc,
    act: (AppLifeCycleBloc bloc) =>
        setAppLifeCycleState(AppLifecycleState.resumed),
    expect: () => <dynamic>[const AppLifeCycleState.resumed()],
  );
}
