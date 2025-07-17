import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/app/config/chopper_config.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';

part 'login_request.dto.freezed.dart';
part 'login_request.dto.g.dart';

@freezed
sealed class LoginRequestDTO with _$LoginRequestDTO {
  const factory LoginRequestDTO({required String username, required String password, int? expiresInMins}) =
      _LoginRequestDTO;

  const LoginRequestDTO._();

  factory LoginRequestDTO.fromJson(Map<String, dynamic> json) => _$LoginRequestDTOFromJson(json);

  factory LoginRequestDTO.fromDomain(LoginRequest loginRequest) => LoginRequestDTO(
    username: loginRequest.username.getValue(),
    password: loginRequest.password.getValue(),
    expiresInMins: loginRequest.expiresInMins?.getValue().toInt() ?? ChopperConfig.sessionTimeout,
  );
}
