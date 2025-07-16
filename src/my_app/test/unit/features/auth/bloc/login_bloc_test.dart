import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/features/auth/domain/bloc/login/login_bloc.dart';

import '../../../../utils/generated_mocks.mocks.dart';

void main() {
  group('LoginBloc', () {
    late MockIAuthRepository authRepository;
    late MockILocalStorageRepository localStorageRepository;
    late MockFailureHandler failureHandler;
    late LoginBloc loginBloc;
    late String username;
    late String password;
    late Failure failure;

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
    });

    group('initialize', () {
      blocTest<LoginBloc, LoginState>(
        'should emit state with null username when no previous login exists',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(null));

          return LoginBloc(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginBloc bloc) => bloc.initialize(),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false)],
        verify: (_) {
          verify(localStorageRepository.getLastLoggedInUsername()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'should emit state with saved username when previous login exists',
        build: () {
          provideDummy(Either<Failure, String?>.right(username));
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => Either<Failure, String?>.right(username));

          return LoginBloc(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginBloc bloc) => bloc.initialize(),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false, username: username)],
        verify: (_) {
          verify(localStorageRepository.getLastLoggedInUsername()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'should handle storage access failure during initialization',
        build: () {
          when(
            localStorageRepository.getLastLoggedInUsername(),
          ).thenAnswer((_) async => left(const Failure.deviceInfo('Storage access failed')));

          return LoginBloc(authRepository, localStorageRepository, failureHandler);
        },
        act: (LoginBloc bloc) => bloc.initialize(),
        expect: () => <LoginState>[],
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
        loginBloc = LoginBloc(authRepository, localStorageRepository, failureHandler)..initialize();
      });

      blocTest<LoginBloc, LoginState>(
        'should emit state with updated username',
        build: () => loginBloc,
        act: (LoginBloc bloc) => bloc.onUsernameChanged('test_$username'),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false, username: 'test_$username')],
      );

      blocTest<LoginBloc, LoginState>(
        'should handle empty username input',
        build: () => loginBloc,
        act: (LoginBloc bloc) => bloc.onUsernameChanged(''),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false, username: '')],
      );

      blocTest<LoginBloc, LoginState>(
        'should handle special characters in username',
        build: () => loginBloc,
        act: (LoginBloc bloc) => bloc.onUsernameChanged('user@domain.com'),
        expect: () => <LoginState>[LoginState.initial().copyWith(isLoading: false, username: 'user@domain.com')],
      );
    });

    group('login', () {
      setUp(() {
        provideDummy(Either<Failure, String?>.right(null));
        when(
          localStorageRepository.getLastLoggedInUsername(),
        ).thenAnswer((_) async => Either<Failure, String?>.right(null));
        loginBloc = LoginBloc(authRepository, localStorageRepository, failureHandler)..initialize();
        failure = const Failure.server(StatusCode.http500, 'INTERNAL SERVER ERROR');
      });

      blocTest<LoginBloc, LoginState>(
        'should emit loading and success states when login is successful',
        build: () {
          provideDummy(Either<Failure, Unit>.right(unit));
          provideDummy(Either<Failure, String?>.right(null));
          when(authRepository.login(any)).thenAnswer((_) async => Either<Failure, Unit>.right(unit));

          return loginBloc;
        },
        act: (LoginBloc bloc) => bloc.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocPresentationTest<LoginBloc, LoginState, LoginPresentationEvent>(
        'should emit onSuccess presentation event when login is successful',
        build: () {
          provideDummy(Either<Failure, Unit>.right(unit));
          provideDummy(Either<Failure, String?>.right(null));
          when(authRepository.login(any)).thenAnswer((_) async => Either<Failure, Unit>.right(unit));

          return loginBloc;
        },
        act: (LoginBloc bloc) => bloc.login(username, password),
        expectPresentation: () => const <LoginPresentationEvent>[LoginPresentationEvent.onSuccess()],
      );

      blocTest<LoginBloc, LoginState>(
        'should emit loading and failure states when login fails',
        build: () {
          provideDummy(Either<Failure, Unit>.left(failure));
          provideDummy(Either<Failure, String?>.right(null));
          when(authRepository.login(any)).thenAnswer((_) async => Either<Failure, Unit>.left(failure));

          return loginBloc;
        },
        act: (LoginBloc bloc) => bloc.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'should handle unexpected error during login',
        build: () {
          provideDummy(Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
          provideDummy(Either<Failure, String?>.right(null));
          when(authRepository.login(any)).thenThrow(Exception('Unexpected error'));

          return loginBloc;
        },
        act: (LoginBloc bloc) => bloc.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'should handle validation error for invalid password',
        build: () {
          provideDummy(
            Either<Failure, Unit>.left(
              const Failure.validation(EmptyStringValidationError('password', 'Invalid Password')),
            ),
          );
          provideDummy(Either<Failure, String?>.right(null));
          when(authRepository.login(any)).thenAnswer(
            (_) async => left(const Failure.validation(EmptyStringValidationError('password', 'Invalid Password'))),
          );

          return loginBloc;
        },
        act: (LoginBloc bloc) => bloc.login(username, 'pass'),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'should handle authentication failure',
        build: () {
          const Failure authFailure = Failure.authentication('Invalid credentials');
          provideDummy(Either<Failure, Unit>.left(authFailure));
          provideDummy(Either<Failure, String?>.right(null));
          when(authRepository.login(any)).thenAnswer((_) async => left(authFailure));

          return loginBloc;
        },
        act: (LoginBloc bloc) => bloc.login(username, password),
        expect: () => <LoginState>[
          LoginState.initial().copyWith(username: username),
          LoginState(isLoading: false, username: username),
        ],
        verify: (_) {
          verify(authRepository.login(any)).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'should handle network timeout during login',
        build: () {
          provideDummy(Either<Failure, String?>.right(null));
          when(authRepository.login(any)).thenThrow(Exception('Connection timeout'));

          return loginBloc;
        },
        act: (LoginBloc bloc) => bloc.login(username, password),
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
