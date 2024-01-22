import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/hidable/hidable_bloc.dart';

void main() {
  late HidableBloc hidableBloc;

  setUp(() => hidableBloc = HidableBloc());

  tearDown(() => hidableBloc.close());

  group('Hidable switchTheme ', () {
    blocTest<HidableBloc, bool>(
      'should emit a true state',
      build: () => hidableBloc,
      act: (HidableBloc bloc) async => bloc.setVisibility(isVisible: true),
      expect: () => <dynamic>[true],
    );
    blocTest<HidableBloc, bool>(
      'should emit a false state',
      build: () => hidableBloc,
      act: (HidableBloc bloc) async => bloc.setVisibility(isVisible: false),
      expect: () => <dynamic>[false],
    );
  });
}
