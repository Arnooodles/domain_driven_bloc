import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/failures.dart';
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
        when(userRepository.user).thenAnswer((_) async => none());

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        AuthState.initial().copyWith(isLoading: true),
        authBloc.state.copyWith(status: AuthStatus.unauthenticated, user: null),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => some(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        AuthState.initial().copyWith(isLoading: true),
        authBloc.state
            .copyWith(status: AuthStatus.authenticated, user: mockUser),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        AuthState.initial().copyWith(isLoading: true),
        authBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('AuthBloc getUser ', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => some(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
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
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('AuthBloc logout ', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(authRepository.logout()).thenAnswer((_) async => right(unit));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLogout: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          isLogout: false,
        ),
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
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLogout: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state.copyWith(
          isLogout: false,
          failure: Failure.unexpected(throwsException.toString()),
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
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLogout: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state.copyWith(
          isLogout: false,
          failure: Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
  });

  group('AuthBloc authenticate', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated user state',
      build: () => authBloc,
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <dynamic>[
        authBloc.state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        authBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });
}
