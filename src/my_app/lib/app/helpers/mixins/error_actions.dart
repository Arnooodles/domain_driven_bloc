import 'package:flutter/foundation.dart';
import 'package:toastification/toastification.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/core/domain/bloc/app_localization/app_localization_bloc.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';

mixin ErrorActions {
  final I18n _localization = getIt<AppLocalizationBloc>().state;

  ToastificationItem? _activeToast;

  void onServerError(ServerError error) {
    if (_activeToast?.isRunning ?? false) return;

    _activeToast = DialogUtils.showError(error.error ?? _localization.common.error.generic);
  }

  void onDeviceRelatedError(Exception error) {
    if (_activeToast?.isRunning ?? false) return;
    final String message =
        switch (error) {
          DeviceStorageError(:final String error?) => error,
          DeviceInfoError(:final String error?) => error,
          _ => null,
        } ??
        _localization.common.error.generic;
    _activeToast = DialogUtils.showError(message);
  }

  void onValidationError(ValidationFailure error) {
    if (_activeToast?.isRunning ?? false) return;
    _activeToast = DialogUtils.showError(error.error.message);
  }

  void onGenericError(Exception error) {
    if (_activeToast?.isRunning ?? false) return;
    final String message = error is UnexpectedError && kDebugMode
        ? error.error ?? _localization.common.error.generic
        : _localization.common.error.generic;
    _activeToast = DialogUtils.showError(message);
  }
}
