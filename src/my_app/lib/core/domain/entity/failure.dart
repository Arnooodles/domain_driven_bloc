import 'package:fpvalidate/fpvalidate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure implements Exception {
  const factory Failure.unexpected(String? error) = UnexpectedError;

  const factory Failure.serverError(StatusCode code, String? error) = ServerError;

  const factory Failure.validationFailure(ValidationError error) = ValidationFailure;

  const factory Failure.userNotFound() = UserNotFound;
}
