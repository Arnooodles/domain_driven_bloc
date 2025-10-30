import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/cubit/hidable/hidable_cubit.dart';

void main() {
  late HidableCubit hidableCubit;

  setUp(() => hidableCubit = HidableCubit());

  tearDown(() => hidableCubit.close());

  group('Hidable switchTheme ', () {
    blocTest<HidableCubit, bool>(
      'should emit a true state',
      build: () => hidableCubit,
      act: (HidableCubit bloc) async => bloc.setVisibility(isVisible: true),
      expect: () => <dynamic>[true],
    );
    blocTest<HidableCubit, bool>(
      'should emit a false state',
      build: () => hidableCubit,
      act: (HidableCubit bloc) async => bloc.setVisibility(isVisible: false),
      expect: () => <dynamic>[false],
    );
  });
}
