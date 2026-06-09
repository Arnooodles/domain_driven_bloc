import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/cubit/auth/auth_cubit.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

void main() {
  group(AuthCubit, () {
    late MockIUserRepository userRepository;
    late MockIAuthRepository authRepository;
    late MockILocalStorageRepository localStorageRepository;
    late MockFailureHandler failureHandler;
    late AuthCubit authCubit;

    setUp(() {
      userRepository = MockIUserRepository();
      authRepository = MockIAuthRepository();
      localStorageRepository = MockILocalStorageRepository();
      failureHandler = MockFailureHandler();
      authCubit = AuthCubit(userRepository, authRepository, localStorageRepository, failureHandler);

      // Register dummy values to prevent Mockito's MissingDummyValueError under randomized ordering.
      provideDummy(TaskEither<Failure, User>.right(mockUser));
      provideDummy(TaskEither<Failure, String?>.right('access_token'));
      provideDummy(TaskEither<Failure, Unit>.right(unit));
    });

    tearDown(() async {
      await authCubit.close();
      reset(userRepository);
      reset(authRepository);
      reset(localStorageRepository);
      reset(failureHandler);
    });

    group('initialize', () {
      blocTest<AuthCubit, AuthState>(
        'should emit unauthenticated state when no access token exists',
        build: () {
          provideDummy(TaskEither<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          provideDummy(TaskEither<Failure, String?>.right(null));
          when(
            userRepository.user,
          ).thenReturn(TaskEither<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          when(localStorageRepository.getAccessToken()).thenReturn(TaskEither<Failure, String?>.right(null));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.initialize(),
        expect: () => const <AuthState>[AuthState.initial(), AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit unauthenticated state when access token exists but user fetch fails',
        build: () {
          provideDummy(TaskEither<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          provideDummy(TaskEither<Failure, String?>.right('access_token'));
          when(
            userRepository.user,
          ).thenReturn(TaskEither<Failure, User>.left(const Failure.authentication('Authentication Failed')));
          when(localStorageRepository.getAccessToken()).thenReturn(TaskEither<Failure, String?>.right('access_token'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.initialize(),
        expect: () => const <AuthState>[AuthState.initial(), AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit authenticated state when user is successfully fetched',
        build: () {
          provideDummy(TaskEither<Failure, User>.right(mockUser));
          provideDummy(TaskEither<Failure, String?>.right('access_token'));
          when(userRepository.user).thenReturn(TaskEither<Failure, User>.right(mockUser));
          when(localStorageRepository.getAccessToken()).thenReturn(TaskEither<Failure, String?>.right('access_token'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.initialize(),
        expect: () => <AuthState>[const AuthState.initial(), AuthState.authenticated(user: mockUser)],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should handle server error during initialization',
        build: () {
          provideDummy(TaskEither<Failure, String?>.right('access_token'));
          when(userRepository.user).thenReturn(
            TaskEither<Failure, User>.left(const Failure.server(StatusCode.http500, 'Internal server error')),
          );
          when(localStorageRepository.getAccessToken()).thenReturn(TaskEither<Failure, String?>.right('access_token'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.initialize(),
        expect: () => <AuthState>[const AuthState.initial(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should handle storage access failure during initialization',
        build: () {
          when(
            localStorageRepository.getAccessToken(),
          ).thenReturn(TaskEither<Failure, String?>.left(const Failure.deviceInfo('Storage access failed')));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.initialize(),
        expect: () => const <AuthState>[AuthState.initial()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verifyNever(userRepository.user);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should handle network error during initialization',
        build: () {
          provideDummy(TaskEither<Failure, String?>.right('access_token'));
          when(
            userRepository.user,
          ).thenReturn(TaskEither<Failure, User>.left(const Failure.server(StatusCode.http404, 'User not found')));
          when(localStorageRepository.getAccessToken()).thenReturn(TaskEither<Failure, String?>.right('access_token'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.initialize(),
        expect: () => <AuthState>[const AuthState.initial(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should handle unexpected exception during initialization',
        build: () {
          provideDummy(TaskEither<Failure, String?>.right('access_token'));
          provideDummy(TaskEither<Failure, User>.right(mockUser));
          when(localStorageRepository.getAccessToken()).thenThrow(Exception('Unexpected storage error'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.initialize(),
        expect: () => <AuthState>[const AuthState.initial(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(localStorageRepository.getAccessToken()).called(1);
          verifyNever(userRepository.user);
        },
      );
    });

    group('getUser', () {
      setUp(() async {
        authCubit = AuthCubit(userRepository, authRepository, localStorageRepository, failureHandler);
        provideDummy(TaskEither<Failure, User>.right(mockUser));
        when(userRepository.user).thenReturn(TaskEither<Failure, User>.right(mockUser));
      });

      blocTest<AuthCubit, AuthState>(
        'should emit authenticated state when user is successfully fetched',
        build: () {
          provideDummy(TaskEither<Failure, User>.right(mockUser));
          when(userRepository.user).thenReturn(TaskEither<Failure, User>.right(mockUser));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.getUser(),
        expect: () => <AuthState>[const AuthState.loading(), AuthState.authenticated(user: mockUser)],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit loading state and stop when user fetch returns unauthorized',
        build: () {
          provideDummy(TaskEither<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')));
          when(
            userRepository.user,
          ).thenReturn(TaskEither<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.getUser(),
        expect: () => const <AuthState>[AuthState.loading()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit failure state when unexpected error occurs',
        build: () {
          when(userRepository.user).thenThrow(Exception('Unexpected error'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.getUser(),
        expect: () => <AuthState>[const AuthState.loading()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should handle network timeout during user fetch',
        build: () {
          when(userRepository.user).thenThrow(Exception('Connection timeout'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.getUser(),
        expect: () => <AuthState>[const AuthState.loading()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );
    });

    group('logout', () {
      setUp(() async {
        authCubit = AuthCubit(userRepository, authRepository, localStorageRepository, failureHandler);
        provideDummy(TaskEither<Failure, User>.right(mockUser));
        when(userRepository.user).thenReturn(TaskEither<Failure, User>.right(mockUser));
      });

      blocTest<AuthCubit, AuthState>(
        'should emit unauthenticated state when logout is successful',
        build: () {
          provideDummy(TaskEither<Failure, Unit>.right(unit));
          when(authRepository.logout()).thenReturn(TaskEither<Failure, Unit>.right(unit));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.logout(),
        expect: () => const <AuthState>[AuthState.loading(), AuthState.unauthenticated()],
        verify: (_) {
          verify(authRepository.logout()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit unauthenticated state when logout fails',
        build: () {
          provideDummy(TaskEither<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
          when(
            authRepository.logout(),
          ).thenReturn(TaskEither<Failure, Unit>.left(Failure.unexpected(Exception('Unexpected error').toString())));
          when(failureHandler.handleFailure(any)).thenReturn(null);
          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.logout(),
        expect: () => <AuthState>[const AuthState.loading(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(authRepository.logout()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit unauthenticated state when logout throws exception',
        build: () {
          when(authRepository.logout()).thenThrow(Exception('Unexpected error'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.logout(),
        expect: () => <AuthState>[const AuthState.loading(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(authRepository.logout()).called(1);
        },
      );
    });

    group('authenticate', () {
      setUp(() async {
        authCubit = AuthCubit(userRepository, authRepository, localStorageRepository, failureHandler);
        provideDummy(TaskEither<Failure, User>.right(mockUser));
        when(userRepository.user).thenReturn(TaskEither<Failure, User>.right(mockUser));
      });

      blocTest<AuthCubit, AuthState>(
        'should emit authenticated state when authentication is successful',
        build: () => authCubit,
        act: (AuthCubit cubit) => cubit.authenticate(),
        expect: () => <AuthState>[const AuthState.loading(), AuthState.authenticated(user: mockUser)],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit unauthenticated state when authentication fails',
        build: () {
          provideDummy(TaskEither<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')));
          when(
            userRepository.user,
          ).thenReturn(TaskEither<Failure, User>.left(const Failure.server(StatusCode.http401, 'unauthorized')));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.authenticate(),
        expect: () => <AuthState>[const AuthState.loading(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit unauthenticated state when authentication throws exception',
        build: () {
          when(userRepository.user).thenThrow(Exception('Unexpected error'));

          return authCubit;
        },
        act: (AuthCubit cubit) => cubit.authenticate(),
        expect: () => <AuthState>[const AuthState.loading(), const AuthState.unauthenticated()],
        verify: (_) {
          verify(userRepository.user).called(1);
        },
      );
    });
  });
}
