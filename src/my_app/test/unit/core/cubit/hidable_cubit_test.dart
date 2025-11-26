import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/cubit/hidable/hidable_cubit.dart';

void main() {
  group(HidableCubit, () {
    group('setVisibility', () {
      blocTest<HidableCubit, bool>(
        'should emit a true state',
        build: HidableCubit.new,
        act: (HidableCubit cubit) => cubit.setVisibility(isVisible: true),
        expect: () => <bool>[true],
      );

      blocTest<HidableCubit, bool>(
        'should emit a false state',
        build: HidableCubit.new,
        act: (HidableCubit cubit) => cubit.setVisibility(isVisible: false),
        expect: () => <bool>[false],
      );
    });
  });
}
