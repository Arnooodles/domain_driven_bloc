import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';
import 'package:very_good_core/features/auth/data/dto/login_response.dto.dart';
import 'package:very_good_core/features/auth/data/repository/auth_repository.dart';

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
    loginResponseDTO = const LoginResponseDTO(accessToken: 'accessToken');
  });

  tearDown(() {
    provideDummy(mockChopperClient);
    authService.client.dispose();
    reset(authService);
    reset(localStorageRepository);
  });

  group('Login', () {
    test('should return a unit when login is successful', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.login(
        ValueString('username', fieldName: 'username'),
        Password('password'),
      );

      expect(result.isRight(), true);
    });

    test('should return a failure when login encounters a server error', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.login(
        ValueString('username', fieldName: 'username'),
        Password('password'),
      );

      expect(result.isLeft(), true);
    });

    test('should return a failure when login encounters an unexpected error', () async {
      when(authService.login(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.login(
        ValueString('username', fieldName: 'username'),
        Password('password'),
      );

      expect(result.isLeft(), true);
    });
    test('should return a failure when an error occurs when saving the access token', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.login(
        ValueString('username', fieldName: 'username'),
        Password('password'),
      );

      expect(result.isLeft(), true);
    });
    test('should return a failure when an error occurs when saving the refresh token', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setLastLoggedInUsername(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.login(
        ValueString('username', fieldName: 'username'),
        Password('password'),
      );

      expect(result.isLeft(), true);
    });
    test('should return a failure when an error occurs when saving the last logged in email', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(
        authService.login(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setLastLoggedInUsername(any)).thenThrow(Exception('Unexpected error'));

      final Either<Failure, Unit> result = await authRepository.login(
        ValueString('username', fieldName: 'username'),
        Password('password'),
      );

      expect(result.isLeft(), true);
    });
  });
  group('Logout', () {
    test('should return a unit when logout is successful', () async {
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result.isRight(), true);
    });

    test('should return a failure when logout encounters an unexpected error', () async {
      when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result.isLeft(), true);
    });
    test('should return a failure when an error occurs when clearing the access token', () async {
      when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result.isLeft(), true);
    });
    test('should return a failure when an error occurs when clearing the refresh token', () async {
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenThrow(Exception('Unexpected error'));

      final Either<Failure, Unit> result = await authRepository.logout();

      expect(result.isLeft(), true);
    });
  });
  group('RefreshToken', () {
    test('should return a unit when refreshToken is successful', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => 'refreshToken');
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result.isRight(), true);
    });

    test('should return a failure when no refresh token is found', () async {
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => null);

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result.isLeft(), true);
    });

    test('should return a failure when refreshToken encounters a server error', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => 'refreshToken');
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result.isLeft(), true);
    });

    test('should return a failure when refreshToken encounters an unexpected error', () async {
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => 'refreshToken');
      when(authService.refreshToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result.isLeft(), true);
    });

    test('should return a failure when an error occurs when saving the access token', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => 'refreshToken');
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
      when(localStorageRepository.setRefreshToken(any)).thenAnswer((_) async => Future.value);

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result.isLeft(), true);
    });
    test('should return a failure when an error occurs when saving the refresh token', () async {
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.getRefreshToken()).thenAnswer((_) async => 'refreshToken');
      when(
        authService.refreshToken(any),
      ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      when(localStorageRepository.setAccessToken(any)).thenAnswer((_) async => Future.value);
      when(localStorageRepository.setRefreshToken(any)).thenThrow(Exception('Unexpected error'));

      final Either<Failure, Unit> result = await authRepository.refreshToken();

      expect(result.isLeft(), true);
    });
  });
}
