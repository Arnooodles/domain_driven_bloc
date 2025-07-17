import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/app/helpers/extensions/object_ext.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';
import 'package:very_good_core/features/auth/domain/entity/login_response.dart';

part 'login_response.dto.freezed.dart';
part 'login_response.dto.g.dart';

@freezed
sealed class LoginResponseDTO with _$LoginResponseDTO {
  const factory LoginResponseDTO({required String accessToken, String? refreshToken}) = _LoginResponseDTO;

  const LoginResponseDTO._();

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) => _$LoginResponseDTOFromJson(json);

  factory LoginResponseDTO.fromDomain(LoginResponse loginResponse) => LoginResponseDTO(
    accessToken: loginResponse.accessToken.getValue(),
    refreshToken: loginResponse.refreshToken?.getValue(),
  );

  LoginResponse toDomain() => LoginResponse(
    accessToken: ValueString(accessToken, fieldName: 'accessToken'),
    refreshToken: refreshToken.let((String value) => ValueString(value, fieldName: 'refreshToken')),
  );
}
