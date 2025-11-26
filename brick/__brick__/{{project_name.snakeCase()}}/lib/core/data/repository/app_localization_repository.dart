import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_app_localization_repository.dart';

@LazySingleton(as: IAppLocalizationRepository)
class AppLocalizationRepository implements IAppLocalizationRepository {
  @override
  AppLocale findDeviceLocale() => AppLocaleUtils.findDeviceLocale();
}
