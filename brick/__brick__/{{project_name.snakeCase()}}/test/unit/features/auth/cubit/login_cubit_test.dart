import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/cubit/login/login_cubit.dart';

import '../../../../utils/generated_mocks.mocks.dart';

void main() {
  group(LoginCubit, () {
    late MockIAuthRepository authRepository;
    late MockILocalStorageRepository localStorageRepository;
    late MockFailureHandler failureHandler;
    late LoginCubit loginCubit;
    late String username;
    late String password;

    setUp(() {
      authRepository = MockIAuthRepository();
      localStorageRepository = MockILocalStorageRepository();
      failureHandler = MockFailureHandler();
      username = 'username';
      password = 'password';
    });

    tearDown(() {
      reset(localStorageRepository);
      reset(authRepository);
      reset(failureHandler);
    });

    group('initialize', () {
      blocTest<LoginCubit, LoginState>(
        'should emit state with null username when no previous login exists',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.initialize(),
        expect: () => <LoginState>[LoginState.initial(), LoginState.initial().copyWith(isLoading: false)],
        verify: (_) {
          verify(localStorageRepository.getLastLoggedInUsername()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should emit state with saved username when previous login exists',
        build: () {
          provideDummy(Either<Failure, String?>.right(username));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(username));

          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.initialize(),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState.initial().copyWith(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(localStorageRepository.getLastLoggedInUsername()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should handle storage access failure during initialization',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => left(const Failure.deviceInfo('Storage access failed')));

          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.initialize(),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false)],
        verify: (_) {
          verify(localStorageRepository.getLastLoggedInUsername()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should handle unexpected exception during initialization',
        build: () {
          provideDummy(Either<Failure, String?>.right(username));
          when(localStorageRepository.getLastLoggedInUsername()).thenThrow(Exception('Unexpected error'));

          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.initialize(),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false)],
        verify: (_) {
          verify(localStorageRepository.getLastLoggedInUsername()).called(1);
        },
      );
    });

    group('onUsernameChanged', () {
      setUp(() {
        provideDummy(Either<Failure, String?>.right(null));
        when(
          localStorageRepository.getLastLoggedInUsername(),
        ).thenAnswer((_) async => Either<Failure, String?>.right(null));
        loginCubit = LoginCubit(authRepository, localStorageRepository, failureHandler);
      });

      blocTest<LoginCubit, LoginState>(
        'should emit state with updated username',
        build: () => loginCubit,
        act: (LoginCubit cubit) => cubit.onUsernameChanged('test_$username'),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false, username: 'test_$username')],
      );

      blocTest<LoginCubit, LoginState>(
        'should handle empty username input',
        build: () => loginCubit,
        act: (LoginCubit cubit) => cubit.onUsernameChanged(''),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false, username: '')],
      );

      blocTest<LoginCubit, LoginState>(
        'should handle special characters in username',
        build: () => loginCubit,
        act: (LoginCubit cubit) => cubit.onUsernameChanged('user@domain.com'),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false, username: 'user@domain.com')],
      );
    });

    group('login', () {
      blocTest<LoginCubit, LoginState>(
        'should emit loading and success states when login is successful',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          provideDummy(Either<Failure, Unit>.right(unit));
          when(authRepository.login(any)).thenAnswer((_) async => Either<Failure, Unit>.right(unit));
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocPresentationTest<LoginCubit, LoginState, LoginPresentationEvent>(
        'should emit onSuccess presentation event when login is successful',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          provideDummy(Either<Failure, Unit>.right(unit));
          when(authRepository.login(any)).thenAnswer((_) async => Either<Failure, Unit>.right(unit));
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.login(username, password),
        expectPresentation: () => const <LoginPresentationEvent>[LoginPresentationEvent.onSuccess()],
      );

      blocTest<LoginCubit, LoginState>(
        'should emit loading and failure states when login fails',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          const Failure failure = Failure.server(StatusCode.http500, 'INTERNAL SERVER ERROR');
          provideDummy(Either<Failure, Unit>.left(failure));
          when(authRepository.login(any)).thenAnswer((_) async => Either<Failure, Unit>.left(failure));
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should handle unexpected error during login',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          provideDummy(Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
          when(authRepository.login(any)).thenThrow(Exception('Unexpected error'));
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should handle validation error for invalid password',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          provideDummy(
            Either<Failure, Unit>.left(
              const Failure.validation(EmptyStringValidationError('password', 'Invalid Password'), ''),
            ),
          );
          when(authRepository.login(any)).thenAnswer(
            (_) async => left(const Failure.validation(EmptyStringValidationError('password', 'Invalid Password'), '')),
          );
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.login(username, 'pass'),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should handle authentication failure',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          const Failure authFailure = Failure.authentication('Invalid credentials');
          provideDummy(Either<Failure, Unit>.left(authFailure));
          when(authRepository.login(any)).thenAnswer((_) async => left(authFailure));
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should handle network timeout during login',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          when(authRepository.login(any)).thenThrow(Exception('Connection timeout'));
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return LoginCubit(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginCubit cubit) => cubit.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );
    });
  });
}
