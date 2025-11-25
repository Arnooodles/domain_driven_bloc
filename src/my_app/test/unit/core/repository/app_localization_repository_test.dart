import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/core/data/repository/app_localization_repository.dart';
import 'package:very_good_core/core/domain/interface/i_app_localization_repository.dart';

void main() {
  group(AppLocalizationRepository, () {
    late AppLocalizationRepository appLocalizationRepository;

    setUp(() {
      appLocalizationRepository = AppLocalizationRepository();
    });

    test('can be instantiated', () {
      expect(appLocalizationRepository, isNotNull);
      expect(appLocalizationRepository, isA<IAppLocalizationRepository>());
    });

    test('findDeviceLocale returns an AppLocale', () {
      final AppLocale locale = appLocalizationRepository.findDeviceLocale();
      expect(locale, isA<AppLocale>());
    });
  });
}
