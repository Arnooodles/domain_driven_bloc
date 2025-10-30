import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/core/domain/cubit/app_localization/app_localization_cubit.dart';

void main() {
  late AppLocalizationCubit appLocalizationCubit;

  tearDown(() async {
    await appLocalizationCubit.close();
  });

  group('AppLocalizationCubit initialize ', () {
    blocTest<AppLocalizationCubit, I18n>(
      'should emit an I18n state',
      build: () => appLocalizationCubit = AppLocalizationCubit(),
      expect: () => <dynamic>[isA<I18n>()],
    );
  });
}
