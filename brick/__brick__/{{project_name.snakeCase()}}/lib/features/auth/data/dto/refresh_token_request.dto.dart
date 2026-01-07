import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';

part 'refresh_token_request.dto.freezed.dart';
part 'refresh_token_request.dto.g.dart';

@freezed
sealed class RefreshTokenRequestDTO with _$RefreshTokenRequestDTO {
  const factory RefreshTokenRequestDTO({required String refreshToken, int? expiresInMins}) = _RefreshTokenRequestDTO;

  const RefreshTokenRequestDTO._();

  factory RefreshTokenRequestDTO.fromJson(Json json) => _$RefreshTokenRequestDTOFromJson(json);
}
