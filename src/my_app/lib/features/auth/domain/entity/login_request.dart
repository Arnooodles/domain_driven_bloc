import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/app/helpers/extensions/object_ext.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';

part 'login_request.freezed.dart';

@freezed
sealed class LoginRequest with _$LoginRequest {
  const factory LoginRequest({required ValueString username, required Password password, ValueNumeric? expiresInMins}) =
      _LoginRequest;

  const LoginRequest._();

  Option<Failure> get validate => username.validate
      .andThen(() => password.validate)
      .andThen(expiresInMins.optionalValidation)
      .fold(some, (_) => none());
}
