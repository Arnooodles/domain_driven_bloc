import 'package:fpvalidate/fpvalidate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.unexpected(String? message) = UnexpectedError;

  const factory Failure.server(StatusCode code, String? message) = ServerError;

  const factory Failure.deviceStorage(String? message) = DeviceStorageError;

  const factory Failure.deviceInfo(String? message) = DeviceInfoError;

  const factory Failure.authentication(String? message) = AuthenticationError;

  const factory Failure.validation(ValidationError message) = ValidationFailure;
}
