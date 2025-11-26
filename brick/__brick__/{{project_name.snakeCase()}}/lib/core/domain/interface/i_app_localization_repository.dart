import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';

abstract class IAppLocalizationRepository {
  AppLocale findDeviceLocale();
}
