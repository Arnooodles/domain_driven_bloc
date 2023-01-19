import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/app/constants/enum.dart';
import 'package:my_app/core/domain/bloc/my_app/my_app_bloc.dart';
import 'package:my_app/core/domain/interface/i_user_repository.dart';
import 'package:my_app/core/domain/model/failures.dart';
import 'package:my_app/features/auth/domain/interface/i_auth_repository.dart';

import '../../../utils/test_utils.dart';
import 'my_app_bloc_test.mocks.dart';

@GenerateMocks(<Type>[
  IUserRepository,
  MyAppBloc,
  IAuthRepository,
])
void main() {
  late MockIUserRepository userRepository;
  late MockIAuthRepository authRepository;
  late MyAppBloc myAppBloc;

  setUp(() async {
    userRepository = MockIUserRepository();
    authRepository = MockIAuthRepository();
    myAppBloc = MyAppBloc(userRepository, authRepository);
  });

  group('MyAppBloc initialize', () {
    blocTest<MyAppBloc, MyAppState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());

        return myAppBloc;
      },
      act: (MyAppBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        MyAppState.initial().copyWith(isLoading: true),
        myAppBloc.state
            .copyWith(authStatus: AuthStatus.unauthenticated, user: null),
      ],
    );

    blocTest<MyAppBloc, MyAppState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => some(mockUser));

        return myAppBloc;
      },
      act: (MyAppBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        MyAppState.initial().copyWith(isLoading: true),
        myAppBloc.state
            .copyWith(authStatus: AuthStatus.authenticated, user: mockUser),
      ],
    );
    blocTest<MyAppBloc, MyAppState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return myAppBloc;
      },
      act: (MyAppBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        MyAppState.initial().copyWith(isLoading: true),
        myAppBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('MyAppBloc getUser ', () {
    setUp(() async {
      myAppBloc = MyAppBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await myAppBloc.initialize();
    });
    blocTest<MyAppBloc, MyAppState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.getUser(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );

    blocTest<MyAppBloc, MyAppState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => some(mockUser));

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.getUser(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
        ),
      ],
    );
    blocTest<MyAppBloc, MyAppState>(
      'should emit  a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.getUser(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('MyAppBloc logout ', () {
    setUp(() async {
      myAppBloc = MyAppBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await myAppBloc.initialize();
    });
    blocTest<MyAppBloc, MyAppState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(authRepository.logout()).thenAnswer((_) async => right(unit));

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.logout(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );
    blocTest<MyAppBloc, MyAppState>(
      'should emit a failed state',
      build: () {
        when(authRepository.logout()).thenAnswer(
          (_) async => left(Failure.unexpected(throwsException.toString())),
        );

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.logout(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state.copyWith(
          isLoading: false,
          failure: Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
    blocTest<MyAppBloc, MyAppState>(
      'should emit a failed state when unexpected error occurs',
      build: () {
        when(authRepository.logout()).thenThrow(throwsException);

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.logout(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state.copyWith(
          isLoading: false,
          failure: Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
  });

  group('MyAppBloc authenticate', () {
    setUp(() async {
      myAppBloc = MyAppBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await myAppBloc.initialize();
    });
    blocTest<MyAppBloc, MyAppState>(
      'should emit an authenticated user state',
      build: () => myAppBloc,
      act: (MyAppBloc bloc) async => bloc.authenticate(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
        ),
      ],
    );
    blocTest<MyAppBloc, MyAppState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());
        when(authRepository.logout()).thenAnswer((_) async => right(unit));

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.authenticate(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );
    blocTest<MyAppBloc, MyAppState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return myAppBloc;
      },
      act: (MyAppBloc bloc) async => bloc.authenticate(),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        myAppBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });
  group('MyAppBloc switchTheme ', () {
    setUp(() async {
      myAppBloc = MyAppBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await myAppBloc.initialize();
    });
    blocTest<MyAppBloc, MyAppState>(
      'should emit a dark theme mode',
      build: () => myAppBloc,
      act: (MyAppBloc bloc) async => bloc.switchTheme(Brightness.light),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(themeMode: ThemeMode.dark),
      ],
    );
    blocTest<MyAppBloc, MyAppState>(
      'should emit a light theme mode',
      build: () => myAppBloc,
      act: (MyAppBloc bloc) async => bloc.switchTheme(Brightness.dark),
      expect: () => <dynamic>[
        myAppBloc.state.copyWith(themeMode: ThemeMode.light),
      ],
    );
  });
}
