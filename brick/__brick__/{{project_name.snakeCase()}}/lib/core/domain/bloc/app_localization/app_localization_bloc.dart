// ignore_for_file: prefer-bloc-state-suffix

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';

@lazySingleton
class AppLocalizationBloc extends Cubit<I18n> {
  AppLocalizationBloc() : super(AppLocale.values.first.buildSync()) {
    initialize();
  }

  Future<void> initialize() async {
    safeEmit(await AppLocaleUtils.findDeviceLocale().build());

    // TODO: Example on how to implement remote localization
    // try {
    //   // fetch remote locale from a remote service
    //   final String? remoteLocaleString =
    //       await _remoteConfigService.getString(appLocale.languageCode);
    //   if (remoteLocaleString == null) {
    //     throw Exception('Unable to fetch locale remote config');
    //   }
    //   final Map<String, dynamic>? remoteLocale =
    //       json.decode(remoteLocaleString) as Map<String, dynamic>?;
    //   if (remoteLocale == null) {
    //     throw Exception('Unable to decode remote config');
    //   }
    //   final I18n remoteLocalization = AppLocaleUtils.buildWithOverridesFromMap(
    //     locale: appLocale,
    //     isFlatMap: true,
    //     map: remoteLocale,
    //   );
    //   safeEmit(remoteLocalization);
    // } on Exception catch(error){
    //   // if remote config fails, fallback to locale config
    //   safeEmit(
    //     AppLocale.values
    //         .firstWhere(
    //           (AppLocale locale) =>
    //               locale.languageCode == appLocale.languageCode,
    //           orElse: () => AppLocale.values.first,
    //         )
    //         .build(),
    //   );
    // }
  }
}
