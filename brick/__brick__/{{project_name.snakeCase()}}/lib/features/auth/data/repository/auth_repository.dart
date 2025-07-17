import 'package:chopper/chopper.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:{{project_name.snakeCase()}}/app/config/chopper_config.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/int_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/status_code_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/failure_handler.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/login_request.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/login_response.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/refresh_token_request.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/service/auth_service.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  const AuthRepository(this._authService, this._localStorageRepository);

  final ILocalStorageRepository _localStorageRepository;
  final AuthService _authService;

  Logger get _logger => getIt<Logger>();
  FailureHandler get _failureHandler => getIt<FailureHandler>();

  @override
  Future<Either<Failure, Unit>> login(LoginRequest loginRequest) async {
    try {
      final Response<LoginResponseDTO> response = await _authService.login(
        LoginRequestDTO.fromDomain(loginRequest).toJson(),
      );
      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null) {
        final Option<Failure> possibleFailure = response.body!.toDomain().validate;
        return await possibleFailure.fold(() async {
          // Save tokens to local storage
          final List<Either<Failure, Unit>> possibleFailures = await Future.wait(<Future<Either<Failure, Unit>>>[
            _localStorageRepository.setAccessToken(response.body!.accessToken),
            if (response.body!.refreshToken != null)
              _localStorageRepository.setRefreshToken(response.body!.refreshToken!),
            _localStorageRepository.setLastLoggedInUsername(loginRequest.username.getValue()),
          ]);

          return _verifySaving(possibleFailures);
        }, left);
      } else {
        return _failureHandler.handleServerError<Unit>(statusCode, response.error);
      }
    } on Exception catch (error) {
      _logger.e(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      //TODO: add  service to logout
      await Future<void>.delayed(const Duration(milliseconds: 500));

      //clear auth tokens from the local storage
      final List<Either<Failure, Unit>> deleteResults = await Future.wait(<Future<Either<Failure, Unit>>>[
        _localStorageRepository.deleteAccessToken(),
        _localStorageRepository.deleteRefreshToken(),
      ]);

      return _verifySaving(deleteResults);
    } on Exception catch (error) {
      _logger.e(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> refreshToken() async {
    try {
      final Either<Failure, String?> possibleFailure = await _localStorageRepository.getRefreshToken();
      return await possibleFailure.fold(left, (String? refreshToken) async {
        if (refreshToken == null) return left(const Failure.deviceStorage('No refresh token found'));

        final Response<LoginResponseDTO> response = await _authService.refreshToken(
          RefreshTokenRequestDTO(refreshToken: refreshToken, expiresInMins: ChopperConfig.sessionTimeout).toJson(),
        );
        final StatusCode statusCode = response.statusCode.statusCode;

        if (statusCode.isSuccess && response.body != null) {
          // Save tokens to local storage
          final List<Either<Failure, Unit>> possibleFailure = await Future.wait(<Future<Either<Failure, Unit>>>[
            _localStorageRepository.setAccessToken(response.body!.accessToken),
            if (response.body!.refreshToken != null)
              _localStorageRepository.setRefreshToken(response.body!.refreshToken!),
          ]);

          return _verifySaving(possibleFailure);
        } else {
          return _failureHandler.handleServerError<Unit>(statusCode, response.error);
        }
      });
    } on Exception catch (error) {
      _logger.e(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  Either<Failure, Unit> _verifySaving(List<Either<Failure, Unit>> results) =>
      results.firstWhere((Either<Failure, Unit> result) => result.isLeft(), orElse: () => right(unit));
}
