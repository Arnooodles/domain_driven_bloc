import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/core/domain/bloc/app_localization/app_localization_bloc.dart';

void main() {
  late AppLocalizationBloc appLocalizationBloc;

  tearDown(() {
    appLocalizationBloc.close();
  });

  group('AppLocalizationBloc initialize ', () {
    blocTest<AppLocalizationBloc, I18n>(
      'should emit an I18n state',
      build: () => appLocalizationBloc = AppLocalizationBloc(),
      expect: () => <dynamic>[isA<I18n>()],
    );
  });
}
