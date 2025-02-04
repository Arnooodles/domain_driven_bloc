import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/int_ext.dart';
import 'package:very_good_core/app/helpers/extensions/status_code_ext.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/features/auth/data/dto/login_response.dto.dart';
import 'package:very_good_core/features/auth/data/service/auth_service.dart';
import 'package:very_good_core/features/auth/domain/interface/i_auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(
    this._authService,
    this._localStorageRepository,
  );

  final ILocalStorageRepository _localStorageRepository;

  final AuthService _authService;

  @override
  Future<Either<Failure, Unit>> login(
    EmailAddress email,
    Password password,
  ) async {
    try {
      final String emailAddress = email.getOrCrash();
      final Map<String, dynamic> requestBody = <String, dynamic>{
        'email': emailAddress,
        'password': password.getOrCrash(),
      };

      final Response<LoginResponseDTO> response =
          await _authService.login(requestBody);
      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null) {
        // Save tokens to local storage
        await Future.wait(<Future<void>>[
          _localStorageRepository.setAccessToken(response.body!.accessToken),
          _localStorageRepository.setRefreshToken(response.body!.refreshToken),
          _localStorageRepository.setLastLoggedInEmail(emailAddress),
        ]);

        return right(unit);
      } else {
        return left(
          Failure.serverError(statusCode, response.error?.toString() ?? ''),
        );
      }
    } on Exception catch (error) {
      log(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      //TODO: add  service to logout
      await Future<void>.delayed(const Duration(milliseconds: 500));

      //clear auth tokens from the local storage
      await Future.wait(<Future<void>>[
        _localStorageRepository.setAccessToken(null),
        _localStorageRepository.setRefreshToken(null),
      ]);

      return right(unit);
    } on Exception catch (error) {
      log(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }
}
