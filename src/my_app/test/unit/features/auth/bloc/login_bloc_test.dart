import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/core/domain/model/failure.dart';
import 'package:very_good_core/features/auth/domain/bloc/login/login_bloc.dart';
import 'package:very_good_core/features/auth/domain/interface/i_auth_repository.dart';

import 'login_bloc_test.mocks.dart';

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<IAuthRepository>(),
    MockSpec<ILocalStorageRepository>(),
  ],
)
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

  group('LoginBloc initialize', () {
    blocTest<LoginBloc, LoginState>(
      'should emit an null email address',
      build: () {
        when(localStorageRepository.getLastLoggedInEmail())
            .thenAnswer((_) async => null);

        return LoginBloc(authRepository, localStorageRepository);
      },
      act: (LoginBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[const LoginState.initial(isLoading: false)],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit an email address',
      build: () {
        when(localStorageRepository.getLastLoggedInEmail())
            .thenAnswer((_) async => email);

        return LoginBloc(authRepository, localStorageRepository);
      },
      act: (LoginBloc bloc) => bloc.initialize(),
      expect: () =>
          <dynamic>[LoginState.initial(isLoading: false, emailAddress: email)],
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
        LoginState.initial(isLoading: false, emailAddress: 'test_$email'),
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
        when(authRepository.login(any, any))
            .thenAnswer((_) async => right(unit));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, password),
      expect: () => <dynamic>[
        const LoginState.initial(isLoading: true),
        const LoginState.success()
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit a failed state',
      build: () {
        when(authRepository.login(any, any))
            .thenAnswer((_) async => left(failure));

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, password),
      expect: () => <dynamic>[
        const LoginState.initial(isLoading: true),
        LoginState.failed(failure),
        LoginState.initial(isLoading: false, emailAddress: email),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit a unexpected error state',
      build: () {
        when(authRepository.login(any, any)).thenThrow(throwsException);

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, password),
      expect: () => <dynamic>[
        const LoginState.initial(isLoading: true),
        LoginState.failed(
          Failure.unexpected(throwsException.toString()),
        ),
        LoginState.initial(isLoading: false, emailAddress: email),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit an invalid email error state',
      build: () {
        when(authRepository.login(any, any)).thenThrow(throwsException);

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login('email', password),
      expect: () => <dynamic>[
        const LoginState.initial(isLoading: true),
        const LoginState.failed(
          Failure.invalidEmailFormat(),
        ),
        const LoginState.initial(isLoading: false, emailAddress: 'email'),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit an invalid password error state',
      build: () {
        when(authRepository.login(any, any)).thenThrow(throwsException);

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.login(email, 'pass'),
      expect: () => <dynamic>[
        const LoginState.initial(isLoading: true),
        const LoginState.failed(
          Failure.exceedingCharacterLength(min: 6),
        ),
        LoginState.initial(isLoading: false, emailAddress: email),
      ],
    );
  });
}
