import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/profile/presentation/screens/profile_screen.dart';

import '../../../../utils/golden_test_device_scenario.dart';
import '../../../../utils/mock_material_app.dart';
import '../../../../utils/test_utils.dart';
import '../../../core/screens/main_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthBloc>(),
  MockSpec<AppCoreBloc>(),
])
void main() {
  late MockAuthBloc authBlocInitial;
  late MockAuthBloc authBlocLoading;
  late MockAppCoreBloc appCoreBloc;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    authBlocInitial = MockAuthBloc();
    authBlocLoading = MockAuthBloc();
    appCoreBloc = MockAppCoreBloc();

    scrollControllers = <AppScrollController, ScrollController>{
      AppScrollController.home: ScrollController(),
      AppScrollController.profile: ScrollController(),
    };

    when(appCoreBloc.stream).thenAnswer(
      (_) => Stream<AppCoreState>.fromIterable(
        <AppCoreState>[
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
        ],
      ),
    );
    when(appCoreBloc.state).thenAnswer(
      (_) =>
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
    );
    when(appCoreBloc.getScrollController(any))
        .thenAnswer((_) => ScrollController());

    when(authBlocInitial.stream).thenAnswer(
      (_) => Stream<AuthState>.fromIterable(<AuthState>[
        AuthState.authenticated(
          user: mockUser,
        ),
      ]),
    );
    when(authBlocInitial.state).thenAnswer(
      (_) => AuthState.authenticated(
        user: mockUser,
      ),
    );
    when(authBlocLoading.stream).thenAnswer(
      (_) => Stream<AuthState>.fromIterable(<AuthState>[
        const AuthState.loading(),
      ]),
    );
    when(authBlocLoading.state).thenAnswer(
      (_) => const AuthState.loading(),
    );
  });
  Widget buildProfileScreen(AuthBloc authBloc) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => authBloc,
          ),
          BlocProvider<AppCoreBloc>(
            create: (BuildContext context) => appCoreBloc,
          ),
        ],
        child: const MockMaterialApp(
          child: Scaffold(
            body: ProfileScreen(),
          ),
        ),
      );

  group('Profile Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'profile_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: () => buildProfileScreen(authBlocInitial),
          ),
          GoldenTestDeviceScenario(
            name: 'loading',
            builder: () => buildProfileScreen(authBlocLoading),
          ),
        ],
      ),
    );
  });
}
