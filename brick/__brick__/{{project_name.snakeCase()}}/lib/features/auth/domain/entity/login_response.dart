import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';

part 'login_response.freezed.dart';

@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required AuthToken accessToken,
    required AuthToken refreshToken,
  }) = _LoginResponse;

  const LoginResponse._();

  Option<Failure> get failureOption => accessToken.failureOrUnit //
      .andThen(() => refreshToken.failureOrUnit)
      .fold(some, (_) => none());
}
