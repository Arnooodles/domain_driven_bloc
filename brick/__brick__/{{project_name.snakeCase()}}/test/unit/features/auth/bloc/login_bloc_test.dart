import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/login/login_bloc.dart';

import '../../../../utils/generated_mocks.mocks.dart';

void main() {
  late MockIAuthRepository authRepository;
  late MockILocalStorageRepository localStorageRepository;
  late LoginBloc loginBloc;
  late String email;
  late String password;
  late Failure failure;

  setUp(() {
    authRepository = MockIAuthRepository();
    localStorageRepository = MockILocalStorageRepository();
    email = 'email@example.com';
    password = 'password';
  });

  tearDown(() {
    reset(localStorageRepository);
    reset(authRepository);
  });

  group('LoginBloc initialize', () {
    blocTest<LoginBloc, LoginState>(
      'should emit an null email address',
      build: () {
        when(localStorageRepository.getLastLoggedInEmail())
            .thenAnswer((_) async => null);

        return LoginBloc(authRepository, localStorageRepository);
      },
      act: (LoginBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(isLoading: false),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit an email address',
      build: () {
        when(localStorageRepository.getLastLoggedInEmail())
            .thenAnswer((_) async => email);

        return LoginBloc(authRepository, localStorageRepository);
      },
      act: (LoginBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(
          isLoading: false,
          emailAddress: email,
        ),
      ],
    );
  });

  group('LoginBloc onEmailAddressChanged', () {
    setUp(() {
      when(localStorageRepository.getLastLoggedInEmail())
          .thenAnswer((_) async => null);
      loginBloc = LoginBloc(authRepository, localStorageRepository);
    });
    blocTest<LoginBloc, LoginState>(
      'should emit an the new email address',
      build: () => loginBloc,
      act: (LoginBloc bloc) async => bloc.onEmailAddressChanged('test_$email'),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(
          isLoading: false,
          emailAddress: 'test_$email',
        ),
      ],
    );
  });

  group('LoginBloc login', () {
    setUp(() {
      when(localStorageRepository.getLastLoggedInEmail())
          .thenAnswer((_) async => null);
      loginBloc = LoginBloc(authRepository, localStorageRepository);
      failure = const Failure.serverError(
        StatusCode.http500,
        'INTERNAL SERVER ERROR',
      );
    });
    blocTest<LoginBloc, LoginState>(
      'should emit an the a success state',
      build: () {
        provideDummy(
          Either<Failure, Unit>.right(unit),
        );
        when(authRepository.login(any, any))
            .thenAnswer((_) async => Either<Failure, Unit>.right(unit));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, password),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(emailAddress: email),
        LoginState(
          isLoading: false,
          emailAddress: email,
          loginStatus: const LoginStatus.success(),
        ),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit a failed state',
      build: () {
        provideDummy(
          Either<Failure, Unit>.left(failure),
        );
        when(authRepository.login(any, any))
            .thenAnswer((_) async => Either<Failure, Unit>.left(failure));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, password),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(emailAddress: email),
        LoginState(
          isLoading: false,
          emailAddress: email,
          loginStatus: LoginStatus.failed(failure),
        ),
        LoginState(
          isLoading: false,
          emailAddress: email,
          loginStatus: const LoginStatus.initial(),
        ),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit a unexpected error state',
      build: () {
        provideDummy(
          Either<Failure, Unit>.left(
            Failure.unexpected(Exception('Unexpected error').toString()),
          ),
        );
        when(authRepository.login(any, any))
            .thenThrow(Exception('Unexpected error'));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, password),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(emailAddress: email),
        LoginState(
          isLoading: false,
          emailAddress: email,
          loginStatus: LoginStatus.failed(
            Failure.unexpected(Exception('Unexpected error').toString()),
          ),
        ),
        LoginState(
          isLoading: false,
          emailAddress: email,
          loginStatus: const LoginStatus.initial(),
        ),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit an invalid email error state',
      build: () {
        provideDummy(
          Either<Failure, Unit>.left(
            const Failure.invalidEmailFormat(),
          ),
        );
        when(authRepository.login(any, any))
            .thenThrow(Exception('Unexpected error'));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login('email', password),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(emailAddress: 'email'),
        const LoginState(
          isLoading: false,
          emailAddress: 'email',
          loginStatus: LoginStatus.failed(
            Failure.invalidEmailFormat(),
          ),
        ),
        const LoginState(
          isLoading: false,
          emailAddress: 'email',
          loginStatus: LoginStatus.initial(),
        ),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit an invalid password error state',
      build: () {
        provideDummy(
          Either<Failure, Unit>.left(
            const Failure.exceedingCharacterLength(min: 6),
          ),
        );
        when(authRepository.login(any, any))
            .thenThrow(Exception('Unexpected error'));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, 'pass'),
      expect: () => <dynamic>[
        LoginState.initial().copyWith(emailAddress: email),
        LoginState(
          isLoading: false,
          emailAddress: email,
          loginStatus: const LoginStatus.failed(
            Failure.exceedingCharacterLength(min: 6),
          ),
        ),
        LoginState(
          isLoading: false,
          emailAddress: email,
          loginStatus: const LoginStatus.initial(),
        ),
      ],
    );
  });
}
