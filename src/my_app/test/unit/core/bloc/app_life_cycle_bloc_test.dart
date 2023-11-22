import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';

void main() {
  late AppLifeCycleBloc appLifeCycleBloc;

  setUp(() {
    appLifeCycleBloc = AppLifeCycleBloc();
  });

  void setAppLifeCycleState(AppLifecycleState state) {
    final ByteData? message =
        const StringCodec().encodeMessage(state.toString());
    ServicesBinding.instance.channelBuffers
        .push('flutter/lifecycle', message, (_) {});
  }

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
    expect: () => <dynamic>[
      const AppLifeCycleState.detached(),
      const AppLifeCycleState.inactive(),
      const AppLifeCycleState.resumed(),
    ],
  );

  blocTest<AppLifeCycleBloc, AppLifeCycleState>(
    'should emit a detached lifecycle state',
    build: () => appLifeCycleBloc,
    act: (AppLifeCycleBloc bloc) =>
        setAppLifeCycleState(AppLifecycleState.detached),
    expect: () => <dynamic>[],
  );

  blocTest<AppLifeCycleBloc, AppLifeCycleState>(
    'should emit a inactive lifecycle state',
    build: () => appLifeCycleBloc,
    act: (AppLifeCycleBloc bloc) =>
        setAppLifeCycleState(AppLifecycleState.inactive),
    expect: () => <dynamic>[const AppLifeCycleState.inactive()],
  );
}
