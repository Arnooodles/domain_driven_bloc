import 'package:chopper/chopper.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
import 'package:{{project_name.snakeCase()}}/app/config/chopper_config.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/int_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/status_code_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/login_request.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/login_response.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/refresh_token_request.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/service/auth_service.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  const AuthRepository(this._authService, this._localStorageRepository, this._talker);

  final ILocalStorageRepository _localStorageRepository;
  final AuthService _authService;
  final Talker _talker;

  @override
  TaskResult<Unit> login(LoginRequest loginRequest) => TaskResult<Unit>.tryCatch(
    () async {
      final Response<LoginResponseDTO> response = await _authService.login(
        LoginRequestDTO.fromDomain(loginRequest).toJson(),
      );
      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null) {
        final Option<Failure> possibleFailure = response.body!.toDomain().validate;
        return await possibleFailure.fold(() async {
          // Save tokens to local storage
          final List<Result<Unit>> possibleFailures = await Future.wait(<Future<Result<Unit>>>[
            _localStorageRepository.setAccessToken(response.body!.accessToken).run(),
            if (response.body!.refreshToken != null)
              _localStorageRepository.setRefreshToken(response.body!.refreshToken!).run(),
            _localStorageRepository.setLastLoggedInUsername(loginRequest.username.getValue()).run(),
          ]);

          return _verifySaving(possibleFailures).getOrElse((Failure failure) => throw failure);
        }, (Failure failure) => throw failure);
      } else {
        throw Failure.server(statusCode, response.error.toString());
      }
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      if (error is Failure) return error;
      return Failure.unexpected(error.toString());
    },
  );

  @override
  TaskResult<Unit> logout() => TaskResult<Unit>.tryCatch(
    () async {
      //TODO: add  service to logout
      await Future<void>.delayed(Constant.shortDelay);

      //clear auth tokens from the local storage
      final List<Result<Unit>> deleteResults = await Future.wait(<Future<Result<Unit>>>[
        _localStorageRepository.deleteAccessToken().run(),
        _localStorageRepository.deleteRefreshToken().run(),
      ]);

      return _verifySaving(deleteResults).getOrElse((Failure failure) => throw failure);
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      if (error is Failure) return error;
      return Failure.unexpected(error.toString());
    },
  );

  @override
  TaskResult<Unit> refreshToken() => TaskResult<Unit>.tryCatch(
    () async {
      final Result<String?> possibleFailure = await _localStorageRepository.getRefreshToken().run();
      return await possibleFailure.fold((Failure failure) => throw failure, (String? refreshToken) async {
        if (refreshToken == null) throw const Failure.deviceStorage('No refresh token found');

        final Response<LoginResponseDTO> response = await _authService.refreshToken(
          RefreshTokenRequestDTO(refreshToken: refreshToken, expiresInMins: ChopperConfig.sessionTimeout).toJson(),
        );
        final StatusCode statusCode = response.statusCode.statusCode;

        if (statusCode.isSuccess && response.body != null) {
          // Save tokens to local storage
          final List<Result<Unit>> possibleFailures = await Future.wait(<Future<Result<Unit>>>[
            _localStorageRepository.setAccessToken(response.body!.accessToken).run(),
            if (response.body!.refreshToken != null)
              _localStorageRepository.setRefreshToken(response.body!.refreshToken!).run(),
          ]);

          return _verifySaving(possibleFailures).getOrElse((Failure failure) => throw failure);
        } else {
          throw Failure.server(statusCode, response.error.toString());
        }
      });
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      if (error is Failure) return error;
      return Failure.unexpected(error.toString());
    },
  );

  Result<Unit> _verifySaving(List<Result<Unit>> results) =>
      results.firstWhere((Result<Unit> result) => result.isLeft(), orElse: () => right(unit));
}
