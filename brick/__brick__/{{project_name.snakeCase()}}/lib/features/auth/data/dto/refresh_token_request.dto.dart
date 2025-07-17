import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_request.dto.freezed.dart';
part 'refresh_token_request.dto.g.dart';

@freezed
sealed class RefreshTokenRequestDTO with _$RefreshTokenRequestDTO {
  const factory RefreshTokenRequestDTO({required String refreshToken, int? expiresInMins}) = _RefreshTokenRequestDTO;

  const RefreshTokenRequestDTO._();

  factory RefreshTokenRequestDTO.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestDTOFromJson(json);
}
