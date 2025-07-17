import 'package:flutter/foundation.dart';
import 'package:toastification/toastification.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_localization/app_localization_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';

mixin ErrorActions {
  final I18n _localization = getIt<AppLocalizationBloc>().state;
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
    _showErrorOnce(error.message.message);
  }

  void onGenericError(Failure error) {
    final String message = error is UnexpectedError && kDebugMode
        ? error.message ?? _localization.common.error.generic
        : _localization.common.error.generic;
    _showErrorOnce(message);
  }
}
