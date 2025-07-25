import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/app/helpers/extensions/object_ext.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';

part 'login_response.freezed.dart';

@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory LoginResponse({required ValueString accessToken, required ValueString? refreshToken}) = _LoginResponse;

  const LoginResponse._();

  Option<Failure> get validate =>
      accessToken.validate.andThen(refreshToken.optionalValidation).fold(some, (_) => none());
}
