import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

void main() {
  group('AuthBloc', () {
    late MockIUserRepository userRepository;
    late MockIAuthRepository authRepository;
    late MockILocalStorageRepository localStorageRepository;
    late MockFailureHandler failureHandler;
    late AuthBloc authBloc;

    setUp(() {
      userRepository = MockIUserRepository();
      authRepository = MockIAuthRepository();
      localStorageRepository = MockILocalStorageRepository();
      failureHandler = MockFailureHandler();
      authBloc = AuthBloc(userRepository, authRepository, localStorageRepository, failureHandler);
    });

    tearDown(() {
      authBloc.close();
      reset(userRepository);
      reset(authRepository);
      reset(localStorageRepository);
      reset(failureHandler);
    });

    group('initialize', () {
      blocTest<AuthBloc, AuthState>(
        'should emit unauthenticated state when no access token exists',
        build: () {
          provideDummy(Either<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          provideDummy(Either<Failure, String?>.right(null));
          when(
            userRepository.user,
          ).thenAnswer((_) async => Either<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          when(localStorageRepository.getAccessToken()).thenAnswer((_) async => right(null));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.initialize(),
        expect: () => const <AuthState>[AuthState.initial(), AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit unauthenticated state when access token exists but user fetch fails',
        build: () {
          provideDummy(Either<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          provideDummy(Either<Failure, String?>.right('access_token'));
          when(
            userRepository.user,
          ).thenAnswer((_) async => Either<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          when(localStorageRepository.getAccessToken()).thenAnswer((_) async => right('access_token'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.initialize(),
        expect: () => const <AuthState>[AuthState.initial(), AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit authenticated state when user is successfully fetched',
        build: () {
          provideDummy(Either<Failure, User>.right(mockUser));
          provideDummy(Either<Failure, String?>.right('access_token'));
          when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
          when(localStorageRepository.getAccessToken()).thenAnswer((_) async => right('access_token'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.initialize(),
        expect: () => <AuthState>[const AuthState.initial(), AuthState.authenticated(user: mockUser)],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should handle server error during initialization',
        build: () {
          provideDummy(Either<Failure, String?>.right('access_token'));
          when(
            userRepository.user,
          ).thenAnswer((_) async => left(const Failure.server(StatusCode.http500, 'Internal server error')));
          when(localStorageRepository.getAccessToken()).thenAnswer((_) async => right('access_token'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.initialize(),
        expect: () => <AuthState>[const AuthState.initial(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should handle storage access failure during initialization',
        build: () {
          when(
            localStorageRepository.getAccessToken(),
          ).thenAnswer((_) async => left(const Failure.deviceInfo('Storage access failed')));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.initialize(),
        expect: () => const <AuthState>[AuthState.initial()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verifyNever(userRepository.user);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should handle network error during initialization',
        build: () {
          provideDummy(Either<Failure, String?>.right('access_token'));
          when(
            userRepository.user,
          ).thenAnswer((_) async => left(const Failure.server(StatusCode.http404, 'User not found')));
          when(localStorageRepository.getAccessToken()).thenAnswer((_) async => right('access_token'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.initialize(),
        expect: () => <AuthState>[const AuthState.initial(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should handle unexpected exception during initialization',
        build: () {
          provideDummy(Either<Failure, String?>.right('access_token'));
          provideDummy(Either<Failure, User>.right(mockUser));
          when(localStorageRepository.getAccessToken()).thenThrow(Exception('Unexpected storage error'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.initialize(),
        expect: () => <AuthState>[const AuthState.initial()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verifyNever(userRepository.user);
        },
      );
    });

    group('getUser', () {
      setUp(() async {
        authBloc = AuthBloc(userRepository, authRepository, localStorageRepository, failureHandler);
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      });

      blocTest<AuthBloc, AuthState>(
        'should emit authenticated state when user is successfully fetched',
        build: () {
          provideDummy(Either<Failure, User>.right(mockUser));
          when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.getUser(),
        expect: () => <AuthState>[const AuthState.loading(), AuthState.authenticated(user: mockUser)],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit failure state when user fetch returns unauthorized',
        build: () {
          provideDummy(Either<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')));
          when(userRepository.user).thenAnswer(
            (_) async => Either<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')),
          );

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.getUser(),
        expect: () => const <AuthState>[AuthState.loading()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit failure state when unexpected error occurs',
        build: () {
          when(userRepository.user).thenThrow(Exception('Unexpected error'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.getUser(),
        expect: () => <AuthState>[const AuthState.loading()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should handle network timeout during user fetch',
        build: () {
          when(userRepository.user).thenThrow(Exception('Connection timeout'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.getUser(),
        expect: () => <AuthState>[const AuthState.loading()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );
    });

    group('logout', () {
      setUp(() async {
        authBloc = AuthBloc(userRepository, authRepository, localStorageRepository, failureHandler);
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      });

      blocTest<AuthBloc, AuthState>(
        'should emit unauthenticated state when logout is successful',
        build: () {
          provideDummy(Either<Failure, Unit>.right(unit));
          when(authRepository.logout()).thenAnswer((_) async => Either<Failure, Unit>.right(unit));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.logout(),
        expect: () => const <AuthState>[AuthState.loading(), AuthState.unauthenticated()],
        verify: (_) {
          verify(authRepository.logout()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit failure state when logout fails',
        build: () {
          provideDummy(Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
          when(authRepository.logout()).thenAnswer(
            (_) async => Either<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())),
          );

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.logout(),
        expect: () => <AuthState>[const AuthState.loading()],
        verify: (_) {
          verify(authRepository.logout()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit failure state when logout throws exception',
        build: () {
          when(authRepository.logout()).thenThrow(Exception('Unexpected error'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.logout(),
        expect: () => <AuthState>[const AuthState.loading()],
        verify: (_) {
          verify(authRepository.logout()).called(1);
        },
      );
    });

    group('authenticate', () {
      setUp(() async {
        authBloc = AuthBloc(userRepository, authRepository, localStorageRepository, failureHandler);
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user).thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      });

      blocTest<AuthBloc, AuthState>(
        'should emit authenticated state when authentication is successful',
        build: () => authBloc,
        act: (AuthBloc bloc) => bloc.authenticate(),
        expect: () => <AuthState>[const AuthState.loading(), AuthState.authenticated(user: mockUser)],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit unauthenticated state when authentication fails',
        build: () {
          provideDummy(Either<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')));
          when(userRepository.user).thenAnswer(
            (_) async => Either<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')),
          );

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.authenticate(),
        expect: () => <AuthState>[const AuthState.loading(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit failure state when authentication throws exception',
        build: () {
          when(userRepository.user).thenThrow(Exception('Unexpected error'));

          return authBloc;
        },
        act: (AuthBloc bloc) => bloc.authenticate(),
        expect: () => <AuthState>[const AuthState.loading()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );
    });
  });
}
