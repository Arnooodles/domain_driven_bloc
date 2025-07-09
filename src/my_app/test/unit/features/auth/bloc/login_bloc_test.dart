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
  late MockIAuthRepository authRepository;
  late MockILocalStorageRepository localStorageRepository;
  late LoginBloc loginBloc;
  late String username;
  late String password;
  late Failure failure;

  setUp(() {
    authRepository = MockIAuthRepository();
    localStorageRepository = MockILocalStorageRepository();
    username = 'username';
    password = 'password';
  });

  tearDown(() {
    reset(localStorageRepository);
    reset(authRepository);
  });

  group('LoginBloc initialize', () {
    blocTest<LoginBloc, LoginState>(
      'should emit an null username address',
      build: () {
        when(localStorageRepository.getLastLoggedInUsername()).thenAnswer((_) async => null);

        return LoginBloc(authRepository, localStorageRepository);
      },
      act: (LoginBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[LoginState.initial().copyWith(isLoading: false)],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit an username address',
      build: () {
        when(localStorageRepository.getLastLoggedInUsername()).thenAnswer((_) async => username);

        return LoginBloc(authRepository, localStorageRepository);
      },
      act: (LoginBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[LoginState.initial().copyWith(isLoading: false, username: username)],
    );
  });

  group('LoginBloc onUsernameChanged', () {
    setUp(() {
      when(localStorageRepository.getLastLoggedInUsername()).thenAnswer((_) async => null);
      loginBloc = LoginBloc(authRepository, localStorageRepository);
    });
    blocTest<LoginBloc, LoginState>(
      'should emit an the new username address',
      build: () => loginBloc,
      act: (LoginBloc bloc) async => bloc.onUsernameChanged('test_$username'),
      expect: () => <dynamic>[LoginState.initial().copyWith(isLoading: false, username: 'test_$username')],
    );
  });

  group('LoginBloc login', () {
    setUp(() {
      when(localStorageRepository.getLastLoggedInUsername()).thenAnswer((_) async => null);
      loginBloc = LoginBloc(authRepository, localStorageRepository);
      failure = const Failure.serverError(StatusCode.http500, 'INTERNAL SERVER ERROR');
    });
    blocTest<LoginBloc, LoginState>(
      'should emit false loading state when login is successful',
      build: () {
        provideDummy(Either<Failure, Unit>.right(unit));
        when(authRepository.login(any, any)).thenAnswer((_) async => Either<Failure, Unit>.right(unit));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, password),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(username: username),
        LoginState(isLoading: false, username: username),
      ],
    );

    blocPresentationTest<LoginBloc, LoginState, LoginPresentationEvent>(
      'should emit onSuccess when login is successful',
      build: () {
        provideDummy(Either<Failure, Unit>.right(unit));
        when(authRepository.login(any, any)).thenAnswer((_) async => Either<Failure, Unit>.right(unit));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, password),
      expectPresentation: () => const <LoginPresentationEvent>[LoginPresentationEvent.onSuccess()],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit a false loading state even if login fails',
      build: () {
        provideDummy(Either<Failure, Unit>.left(failure));
        when(authRepository.login(any, any)).thenAnswer((_) async => Either<Failure, Unit>.left(failure));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, password),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(username: username),
        LoginState(isLoading: false, username: username),
      ],
    );

    blocPresentationTest<LoginBloc, LoginState, LoginPresentationEvent>(
      'should emit onFailure when login fails',
      build: () {
        provideDummy(Either<Failure, Unit>.left(failure));
        when(authRepository.login(any, any)).thenAnswer((_) async => Either<Failure, Unit>.left(failure));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, password),
      expectPresentation: () => <LoginPresentationEvent>[LoginPresentationEvent.onFailure(failure)],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit a false loading state even if login encounters an unexpected error',
      build: () {
        provideDummy(Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
        when(authRepository.login(any, any)).thenThrow(Exception('Unexpected error'));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, password),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(username: username),
        LoginState(isLoading: false, username: username),
      ],
    );
    blocPresentationTest<LoginBloc, LoginState, LoginPresentationEvent>(
      'should emit onFailure when login encounters an unexpected error',
      build: () {
        provideDummy(Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
        when(authRepository.login(any, any)).thenThrow(Exception('Unexpected error'));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, password),
      expectPresentation: () => <LoginPresentationEvent>[
        LoginPresentationEvent.onFailure(Failure.unexpected(Exception('Unexpected error').toString())),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit a false loading state even if login encounters an invalid password error',
      build: () {
        provideDummy(
          Either<Failure, Unit>.left(
            const Failure.validationFailure(EmptyStringValidationError('password', 'Invalid Password')),
          ),
        );
        when(authRepository.login(any, any)).thenThrow(Exception('Unexpected error'));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, 'pass'),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(username: username),
        LoginState(isLoading: false, username: username),
      ],
    );

    blocPresentationTest<LoginBloc, LoginState, LoginPresentationEvent>(
      'should emit onFailure even if login encounters an invalid password error',
      build: () {
        provideDummy(
          Either<Failure, Unit>.left(
            const Failure.validationFailure(EmptyStringValidationError('password', 'Invalid Password')),
          ),
        );
        when(authRepository.login(any, any)).thenThrow(Exception('Unexpected error'));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(username, 'pass'),
      expectPresentation: () => <LoginPresentationEvent>[
        const LoginPresentationEvent.onFailure(
          Failure.validationFailure(EmptyStringValidationError('password', 'Invalid Password')),
        ),
      ],
    );
  });
}
