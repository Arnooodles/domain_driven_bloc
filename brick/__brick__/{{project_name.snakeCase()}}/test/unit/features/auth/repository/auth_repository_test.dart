import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/login_response.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/repository/auth_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

void main() {
  late MockAuthService authService;
  late MockILocalStorageRepository localStorageRepository;
  late AuthRepository authRepository;
  late LoginResponseDTO loginResponseDTO;

  setUp(() {
    authService = MockAuthService();
    localStorageRepository = MockILocalStorageRepository();
    authRepository = AuthRepository(authService, localStorageRepository);
    loginResponseDTO = const LoginResponseDTO(accessToken: 'accessToken', refreshToken: 'refreshToken');
  });

  tearDown(() {
    provideDummy(mockChopperClient);
    reset(authService);
    reset(localStorageRepository);
  });

  group('Login', () {
    test('login should return unit when successful', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.login(
        LoginRequest(
          username: ValueString('username', fieldName: 'username'),
          password: Password('password'),
        ),
      );

      expect(result, isA<Right<Failure, Unit>>());
    });

    test('login should return failure when server error occurs', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.login(
        LoginRequest(
          username: ValueString('username', fieldName: 'username'),
          password: Password('password'),
        ),
      );

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('login should return failure when unexpected error occurs', () async {
      provideDummy(Either<Failure, Unit>.right(unit));
      when(authService.login(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.login(
        LoginRequest(
          username: ValueString('username', fieldName: 'username'),
          password: Password('password'),
        ),
      );

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('login should return failure when saving access token fails', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.login(
        LoginRequest(
          username: ValueString('username', fieldName: 'username'),
          password: Password('password'),
        ),
      );

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('login should return failure when saving refresh token fails', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(
        localStorageRepository.setRefreshToken(any),
      ).thenAnswer((_) async => left(const Failure.deviceStorage('Storage access failed')));
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.login(
        LoginRequest(
          username: ValueString('username', fieldName: 'username'),
          password: Password('password'),
        ),
      );

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('login should return failure when saving last logged in email fails', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setLastLoggedInUsername(any)).thenThrow(Exception('Unexpected error'));

      final Either<Failure, Unit> result = await authRepository.login(
        LoginRequest(
          username: ValueString('username', fieldName: 'username'),
          password: Password('password'),
        ),
      );

      expect(result, isA<Left<Failure, Unit>>());
    });
  });

  group('Logout', () {
    test('logout should return unit when successful', () async {
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.deleteAccessToken()).thenAnswer((_) async => right(unit));
      when(localStorageRepository.deleteRefreshToken()).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result, isA<Right<Failure, Unit>>());
    });

    test('logout should return failure when unexpected error occurs', () async {
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.deleteAccessToken()).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.deleteRefreshToken()).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('logout should return failure when clearing access token fails', () async {
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.deleteAccessToken()).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.deleteRefreshToken()).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('logout should return failure when clearing refresh token fails', () async {
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.deleteAccessToken()).thenAnswer((_) async => right(unit));
      when(localStorageRepository.deleteRefreshToken()).thenThrow(Exception('Unexpected error'));

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result, isA<Left<Failure, Unit>>());
    });
  });

  group('RefreshToken', () {
    test('refreshToken should return unit when successful', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(Either<Failure, String?>.right('refreshToken'));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => right('refreshToken'));
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result, isA<Right<Failure, Unit>>());
    });

    test('refreshToken should return failure when no refresh token is found', () async {
      provideDummy(Either<Failure, String?>.right(null));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => right(null));

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('refreshToken should return failure when server error occurs', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      provideDummy(Either<Failure, String?>.right('refreshToken'));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => right('refreshToken'));
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('refreshToken should return failure when unexpected error occurs', () async {
      provideDummy(Either<Failure, String?>.right('refreshToken'));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => right('refreshToken'));
      when(authService.refreshToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('refreshToken should return failure when saving access token fails', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(Either<Failure, String?>.right('refreshToken'));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => right('refreshToken'));
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result, isA<Left<Failure, Unit>>());
    });

    test('refreshToken should return failure when saving refresh token fails', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(Either<Failure, String?>.right('refreshToken'));
      provideDummy(Either<Failure, Unit>.right(unit));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => right('refreshToken'));
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => right(unit));
      when(
        localStorageRepository.setRefreshToken(any),
      ).thenAnswer((_) async => left(const Failure.deviceStorage('Storage access failed')));

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result, isA<Left<Failure, Unit>>());
    });
  });
}
