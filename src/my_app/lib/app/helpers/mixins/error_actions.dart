import 'package:flutter/foundation.dart';
import 'package:toastification/toastification.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/core/domain/cubit/app_localization/app_localization_cubit.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';

mixin ErrorActions {
  final I18n _localization = getIt<AppLocalizationCubit>().state;
  ToastificationItem? _activeToast;

  void _showErrorOnce(String message) {
    if (_activeToast?.isRunning ?? false) return;
    _activeToast = DialogUtils.showError(message);
  }

  void onServerError(ServerError error) {
    _showErrorOnce(error.message ?? _localization.common.error.generic);
  }

  void onDeviceRelatedError(Failure error) {
    final String? message = switch (error) {
      DeviceStorageError(:final String? message) => message,
      DeviceInfoError(:final String? message) => message,
      _ => null,
    };
    _showErrorOnce(message ?? _localization.common.error.generic);
  }

  void onValidationError(ValidationFailure error) {
    final String baseMessage = error.message.message;
    if (!kDebugMode) {
      _showErrorOnce(baseMessage);
      return;
    }

    final String valueSuffix = error.value.isNotEmpty ? '\n(${error.value})' : '';
    _showErrorOnce('$baseMessage$valueSuffix');
  }

  void onGenericError(Failure error) {
    final String message = error is UnexpectedError && kDebugMode
        ? error.message ?? _localization.common.error.generic
        : _localization.common.error.generic;
    _showErrorOnce(message);
  }
}
