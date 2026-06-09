import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/login_response.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/repository/auth_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

void main() {
  group(AuthRepository, () {
    late MockAuthService authService;
    late MockILocalStorageRepository localStorageRepository;
    late MockTalker talker;
    late MockFailureHandler failureHandler;
    late AuthRepository authRepository;
    late LoginResponseDTO loginResponseDTO;

    setUp(() {
      authService = MockAuthService();
      localStorageRepository = MockILocalStorageRepository();
      talker = MockTalker();
      failureHandler = MockFailureHandler();
      authRepository = AuthRepository(authService, localStorageRepository, talker);
      loginResponseDTO = const LoginResponseDTO(accessToken: 'accessToken', refreshToken: 'refreshToken');

      // Register dummy values to prevent Mockito's MissingDummyValueError when stubbing/calling mocked methods.
      provideDummy(mockChopperClient);
      provideDummy(generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
      provideDummy(TaskEither<Failure, Unit>.right(unit));
      provideDummy(TaskEither<Failure, String?>.right('refreshToken'));
      provideDummy<Either<Failure, Unit>>(right(unit));
    });

    tearDown(() {
      reset(authService);
      reset(localStorageRepository);
      reset(talker);
      reset(failureHandler);
    });

    group('login', () {
      test('login should return unit when successful', () async {
        when(
          authService.login(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setLastLoggedInUsername(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository
            .login(
              LoginRequest(
                username: ValueString('username', fieldName: 'username'),
                password: Password('password'),
              ),
            )
            .run();

        expect(result, isA<Right<Failure, Unit>>());
      });

      test('login should return failure when server error occurs', () async {
        when(
          failureHandler.handleServerError<Unit>(any, any),
        ).thenReturn(left(const Failure.unexpected('Server error')));
        when(
          authService.login(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setLastLoggedInUsername(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository
            .login(
              LoginRequest(
                username: ValueString('username', fieldName: 'username'),
                password: Password('password'),
              ),
            )
            .run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('login should return failure when unexpected error occurs', () async {
        when(authService.login(any)).thenThrow(Exception('Unexpected error'));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setLastLoggedInUsername(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository
            .login(
              LoginRequest(
                username: ValueString('username', fieldName: 'username'),
                password: Password('password'),
              ),
            )
            .run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('login should return failure when saving access token fails', () async {
        when(
          authService.login(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
        when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setLastLoggedInUsername(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository
            .login(
              LoginRequest(
                username: ValueString('username', fieldName: 'username'),
                password: Password('password'),
              ),
            )
            .run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('login should return failure when saving refresh token fails', () async {
        when(
          authService.login(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(
          localStorageRepository.setRefreshToken(any),
        ).thenReturn(TaskEither<Failure, Unit>.left(const Failure.deviceStorage('Storage access failed')));
        when(localStorageRepository.setLastLoggedInUsername(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository
            .login(
              LoginRequest(
                username: ValueString('username', fieldName: 'username'),
                password: Password('password'),
              ),
            )
            .run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('login should return failure when saving last logged in email fails', () async {
        when(
          authService.login(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setLastLoggedInUsername(any)).thenThrow(Exception('Unexpected error'));

        final Result<Unit> result = await authRepository
            .login(
              LoginRequest(
                username: ValueString('username', fieldName: 'username'),
                password: Password('password'),
              ),
            )
            .run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('login should return failure when LoginResponse entity is invalid', () async {
        const LoginResponseDTO invalidLoginResponseDTO = LoginResponseDTO(
          accessToken: '',
          refreshToken: 'refreshToken',
        );
        when(
          authService.login(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(invalidLoginResponseDTO, 200));

        final Result<Unit> result = await authRepository
            .login(
              LoginRequest(
                username: ValueString('username', fieldName: 'username'),
                password: Password('password'),
              ),
            )
            .run();

        expect(result, isA<Left<Failure, Unit>>());
      });
    });

    group('logout', () {
      test('logout should return unit when successful', () async {
        when(localStorageRepository.deleteAccessToken()).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.deleteRefreshToken()).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository.logout().run();

        expect(result, isA<Right<Failure, Unit>>());
      });

      test('logout should return failure when unexpected error occurs', () async {
        when(localStorageRepository.deleteAccessToken()).thenThrow(Exception('Unexpected error'));
        when(localStorageRepository.deleteRefreshToken()).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository.logout().run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('logout should return failure when clearing refresh token fails', () async {
        when(localStorageRepository.deleteAccessToken()).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.deleteRefreshToken()).thenThrow(Exception('Unexpected error'));

        final Result<Unit> result = await authRepository.logout().run();

        expect(result, isA<Left<Failure, Unit>>());
      });
    });

    group('refreshToken', () {
      test('refreshToken should return unit when successful', () async {
        when(localStorageRepository.getRefreshToken()).thenReturn(TaskEither<Failure, String?>.right('refreshToken'));
        when(
          authService.refreshToken(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository.refreshToken().run();

        expect(result, isA<Right<Failure, Unit>>());
      });

      test('refreshToken should return failure when no refresh token is found', () async {
        when(localStorageRepository.getRefreshToken()).thenReturn(TaskEither<Failure, String?>.right(null));

        final Result<Unit> result = await authRepository.refreshToken().run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('refreshToken should return failure when server error occurs', () async {
        when(
          failureHandler.handleServerError<Unit>(any, any),
        ).thenReturn(left(const Failure.unexpected('Server error')));
        when(localStorageRepository.getRefreshToken()).thenReturn(TaskEither<Failure, String?>.right('refreshToken'));
        when(
          authService.refreshToken(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository.refreshToken().run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('refreshToken should return failure when unexpected error occurs', () async {
        when(localStorageRepository.getRefreshToken()).thenReturn(TaskEither<Failure, String?>.right('refreshToken'));
        when(authService.refreshToken(any)).thenThrow(Exception('Unexpected error'));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository.refreshToken().run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('refreshToken should return failure when saving access token fails', () async {
        when(localStorageRepository.getRefreshToken()).thenReturn(TaskEither<Failure, String?>.right('refreshToken'));
        when(
          authService.refreshToken(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
        when(localStorageRepository.setAccessToken(any)).thenThrow(Exception('Unexpected error'));
        when(localStorageRepository.setRefreshToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));

        final Result<Unit> result = await authRepository.refreshToken().run();

        expect(result, isA<Left<Failure, Unit>>());
      });

      test('refreshToken should return failure when saving refresh token fails', () async {
        when(localStorageRepository.getRefreshToken()).thenReturn(TaskEither<Failure, String?>.right('refreshToken'));
        when(
          authService.refreshToken(any),
        ).thenAnswer((_) async => generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200));
        when(localStorageRepository.setAccessToken(any)).thenReturn(TaskEither<Failure, Unit>.right(unit));
        when(
          localStorageRepository.setRefreshToken(any),
        ).thenReturn(TaskEither<Failure, Unit>.left(const Failure.deviceStorage('Storage access failed')));

        final Result<Unit> result = await authRepository.refreshToken().run();

        expect(result, isA<Left<Failure, Unit>>());
      });
    });
  });
}
