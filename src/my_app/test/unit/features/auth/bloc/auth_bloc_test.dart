import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

void main() {
  late MockIUserRepository userRepository;
  late MockIAuthRepository authRepository;
  late MockILocalStorageRepository localStorageRepository;
  late AuthBloc authBloc;

  setUp(() {
    userRepository = MockIUserRepository();
    authRepository = MockIAuthRepository();
    localStorageRepository = MockILocalStorageRepository();
    authBloc = AuthBloc(userRepository, authRepository, localStorageRepository);
  });

  tearDown(() {
    authBloc.close();
    reset(userRepository);
    reset(authRepository);
    reset(localStorageRepository);
  });

  group('AuthBloc initialize', () {
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null access token',
      build: () {
        provideDummy(Either<Failure, User>.left(const Failure.userNotFound()));
        when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.left(const Failure.userNotFound()));
        when(localStorageRepository.getAccessToken()).thenAnswer((_) async => null);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => const <AuthState>[AuthState.initial(), AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with access token and null user',
      build: () {
        provideDummy(Either<Failure, User>.left(const Failure.userNotFound()));
        when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.left(const Failure.userNotFound()));
        when(localStorageRepository.getAccessToken()).thenAnswer((_) async => 'access_token');

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => const <AuthState>[
        AuthState.initial(),
        AuthState.onFailure(Failure.userNotFound()),
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
        when(localStorageRepository.getAccessToken()).thenAnswer((_) async => 'access_token');
        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <AuthState>[const AuthState.initial(), AuthState.authenticated(user: mockUser)],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user).thenThrow(Exception('Unexpected error'));
        when(localStorageRepository.getAccessToken()).thenAnswer((_) async => 'access_token');

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <AuthState>[
        const AuthState.initial(),
        AuthState.onFailure(Failure.unexpected(Exception('Unexpected error').toString())),
      ],
    );
  });

  group('AuthBloc getUser ', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository, localStorageRepository);
      provideDummy(Either<Failure, User>.right(mockUser));
      when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        provideDummy(Either<Failure, User>.left(const Failure.serverError(StatusCode.http401, 'unauthorized')));
        when(userRepository.user).thenAnswer(
          (_) async => Either<Failure, User>.left(const Failure.serverError(StatusCode.http401, 'unauthorized')),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => const <AuthState>[
        AuthState.loading(),
        AuthState.onFailure(Failure.serverError(StatusCode.http401, 'unauthorized')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <AuthState>[const AuthState.loading(), AuthState.authenticated(user: mockUser)],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit  a failed state',
      build: () {
        when(userRepository.user).thenThrow(Exception('Unexpected error'));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.onFailure(Failure.unexpected(Exception('Unexpected error').toString())),
      ],
    );
  });

  group('AuthBloc logout ', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository, localStorageRepository);
      provideDummy(Either<Failure, User>.right(mockUser));
      when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        provideDummy(Either<Failure, Unit>.right(unit));
        when(authRepository.logout()).thenAnswer((_) async => Either<Failure, Unit>.right(unit));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => const <AuthState>[AuthState.loading(), AuthState.unauthenticated()],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        provideDummy(Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
        when(authRepository.logout()).thenAnswer(
          (_) async => Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.onFailure(Failure.unexpected(Exception('Unexpected error').toString())),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state when unexpected error occurs',
      build: () {
        when(authRepository.logout()).thenThrow(Exception('Unexpected error'));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.onFailure(Failure.unexpected(Exception('Unexpected error').toString())),
      ],
    );
  });

  group('AuthBloc authenticate', () {
    setUp(() async {
      authBloc = AuthBloc(userRepository, authRepository, localStorageRepository);
      provideDummy(Either<Failure, User>.right(mockUser));
      when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated user state',
      build: () => authBloc,
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[const AuthState.loading(), AuthState.authenticated(user: mockUser)],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        provideDummy(Either<Failure, User>.left(const Failure.serverError(StatusCode.http401, 'unauthorized')));
        when(userRepository.user).thenAnswer(
          (_) async => Either<Failure, User>.left(const Failure.serverError(StatusCode.http401, 'unauthorized')),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        const AuthState.onFailure(Failure.serverError(StatusCode.http401, 'unauthorized')),
        const AuthState.unauthenticated(),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(Exception('Unexpected error'));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.onFailure(Failure.unexpected(Exception('Unexpected error').toString())),
      ],
    );
  });
}
