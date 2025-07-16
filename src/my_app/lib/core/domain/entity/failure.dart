import 'package:fpvalidate/fpvalidate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure implements Exception {
  const factory Failure.unexpected(String? error) = UnexpectedError;

  const factory Failure.server(StatusCode code, String? error) = ServerError;

  const factory Failure.deviceStorage(String? error) = DeviceStorageError;

  const factory Failure.deviceInfo(String? error) = DeviceInfoError;

  const factory Failure.authentication(String? error) = AuthenticationError;

  const factory Failure.validation(ValidationError error) = ValidationFailure;
}
