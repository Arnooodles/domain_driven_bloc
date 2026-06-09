// ignore_for_file: prefer-bloc-state-suffix

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_app_localization_repository.dart';

@lazySingleton
class AppLocalizationCubit extends Cubit<I18n> {
  AppLocalizationCubit(this._appLocalizationRepository) : super(AppLocale.values.first.buildSync());

  final IAppLocalizationRepository _appLocalizationRepository;

  Future<void> initialize() async {
    await safeRun(
      action: () async => safeEmit(await _appLocalizationRepository.findDeviceLocale().build()),
      // Fallback to first locale if device locale detection fails
      onException: (Exception _, StackTrace? _) => safeEmit(AppLocale.values.first.buildSync()),
    );

    // TODO: Example on how to implement remote localization
    // try {
    //   // fetch remote locale from a remote service
    //   final String? remoteLocaleString =
    //       await _remoteConfigService.getString(appLocale.languageCode);
    //   if (remoteLocaleString == null) {
    //     throw Exception('Unable to fetch locale remote config');
    //   }
    //   final Json? remoteLocale =
    //       json.decode(remoteLocaleString) as Json?;
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
