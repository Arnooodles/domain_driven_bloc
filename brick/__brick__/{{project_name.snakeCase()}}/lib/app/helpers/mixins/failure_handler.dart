import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/error_actions.dart';
import 'package:{{project_name.snakeCase()}}/core/data/dto/resource_error.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';

@lazySingleton
class FailureHandler with ErrorActions {
  FailureHandler(this._talker);

  final Talker _talker;

  void handleException(Exception error, StackTrace? stackTrace, [ErrorActions? errorActions]) {
    _talker.handle(error, stackTrace);
    handleFailure(Failure.unexpected(error.toString()), errorActions);
  }

  void handleFailure(Failure failure, [ErrorActions? errorActions]) {
    final ErrorActions actions = errorActions ?? this;

    switch (failure) {
      case final ServerError error:
        actions.onServerError(error);
      case final Failure error when error is DeviceStorageError || error is DeviceInfoError:
        actions.onDeviceRelatedError(error);
      case final ValidationFailure error:
        actions.onValidationError(error);
      default:
        actions.onGenericError(failure);
    }
  }

  Result<T> handleServerError<T>(StatusCode statusCode, Object? error) {
    if (error is ResourceError) {
      return left(Failure.server(statusCode, error.message ?? error.toString()));
    }
    return left(Failure.server(statusCode, error?.toString() ?? 'Unknown error'));
  }
}
