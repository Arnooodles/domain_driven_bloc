import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

import '../../../../utils/test_utils.dart';
import 'auth_bloc_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<IUserRepository>(),
  MockSpec<AuthBloc>(),
  MockSpec<IAuthRepository>(),
])
void main() {
  late MockIUserRepository userRepository;
  late MockIAuthRepository authRepository;
  late AuthBloc authBloc;

  setUp(() {
    userRepository = MockIUserRepository();
    authRepository = MockIAuthRepository();
    authBloc = AuthBloc(userRepository, authRepository);
  });

  group('AuthBloc initialize', () {
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user)
            .thenAnswer((_) async => left(const Failure.userNotFound()));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => const <AuthState>[
        AuthState.initial(),
        AuthState.failed(Failure.userNotFound()),
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => right(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <AuthState>[
        const AuthState.initial(),
        AuthState.authenticated(user: mockUser),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <AuthState>[
        const AuthState.initial(),
        AuthState.failed(Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('AuthBloc getUser ', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer(
          (_) async => left(
            const Failure.serverError(StatusCode.http401, 'unauthorized'),
          ),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => const <AuthState>[
        AuthState.loading(),
        AuthState.failed(
          Failure.serverError(StatusCode.http401, 'unauthorized'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => right(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.authenticated(
          user: mockUser,
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit  a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('AuthBloc logout ', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(authRepository.logout()).thenAnswer((_) async => right(unit));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => const <AuthState>[
        AuthState.loading(),
        AuthState.unauthenticated(),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(authRepository.logout()).thenAnswer(
          (_) async => left(Failure.unexpected(throwsException.toString())),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(
          Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state when unexpected error occurs',
      build: () {
        when(authRepository.logout()).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(
          Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
  });

  group('AuthBloc authenticate', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated user state',
      build: () => authBloc,
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.authenticated(
          user: mockUser,
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer(
          (_) async => left(
            const Failure.serverError(StatusCode.http401, 'unauthorized'),
          ),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        const AuthState.failed(
          Failure.serverError(StatusCode.http401, 'unauthorized'),
        ),
        const AuthState.unauthenticated(),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(Failure.unexpected(throwsException.toString())),
      ],
    );
  });
}
