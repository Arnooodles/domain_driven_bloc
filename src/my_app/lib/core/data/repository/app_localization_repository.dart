import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/core/domain/interface/i_app_localization_repository.dart';

@LazySingleton(as: IAppLocalizationRepository)
class AppLocalizationRepository implements IAppLocalizationRepository {
  @override
  AppLocale findDeviceLocale() => AppLocaleUtils.findDeviceLocale();
}
