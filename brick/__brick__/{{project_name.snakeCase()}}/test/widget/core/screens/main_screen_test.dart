import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/route_name.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/screens/main_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/screens/home_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/profile/presentation/screens/profile_screen.dart';

import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/mock_material_app.dart';
import '../../../utils/test_utils.dart';
import 'main_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthBloc>(),
  MockSpec<AppCoreBloc>(),
  MockSpec<PostBloc>(),
  MockSpec<GoRouter>(),
])
void main() {
  late MockAuthBloc authBloc;
  late MockAuthBloc authBlocError;
  late MockAuthBloc authBlocLoading;
  late MockAppCoreBloc appCoreBloc;
  late GoRouter routerHome;
  late MockGoRouter routerProfile;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    authBloc = MockAuthBloc();
    authBlocError = MockAuthBloc();
    authBlocLoading = MockAuthBloc();
    appCoreBloc = MockAppCoreBloc();
    routerProfile = MockGoRouter();
    routerHome = MockGoRouter();

    final AuthState authState = AuthState.authenticated(user: mockUser);
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

    when(authBloc.stream).thenAnswer(
      (_) => Stream<AuthState>.fromIterable(<AuthState>[authState]),
    );
    when(authBloc.state).thenAnswer((_) => authState);

    when(authBlocError.stream).thenAnswer(
      (_) => Stream<AuthState>.fromIterable(<AuthState>[
        const AuthState.failed(
          Failure.unexpected('Unexpected Error'),
        ),
      ]),
    );
    when(authBlocError.state).thenAnswer(
      (_) => const AuthState.failed(
        Failure.unexpected('Unexpected Error'),
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

    when(routerHome.location).thenAnswer((_) => RouteName.home.path);
    when(routerHome.canPop()).thenAnswer((_) => false);

    when(routerProfile.location).thenAnswer((_) => RouteName.profile.path);
    when(routerProfile.canPop()).thenAnswer((_) => false);
  });

  Widget build{{#pascalCase}}{{project_name}}{{/pascalCase}}Screen(
    Widget child,
    GoRouter router,
    AuthBloc authBloc,
  ) =>
      MockMaterialApp(
        child: MockGoRouterProvider(
          router: router,
          child: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<AuthBloc>(
                create: (BuildContext context) => authBloc,
              ),
              BlocProvider<AppCoreBloc>(
                create: (BuildContext context) => appCoreBloc,
              ),
            ],
            child: Scaffold(
              body: MainScreen(
                child: child,
              ),
            ),
          ),
        ),
      );

  group('{{#pascalCase}}{{project_name}}{{/pascalCase}} Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'main_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pumpAndSettle(const Duration(seconds: 6));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'home',
            builder: () => build{{#pascalCase}}{{project_name}}{{/pascalCase}}Screen(
              const HomeScreen(),
              routerHome,
              authBloc,
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'profile',
            builder: () => build{{#pascalCase}}{{project_name}}{{/pascalCase}}Screen(
              const ProfileScreen(),
              routerProfile,
              authBloc,
            ),
          ),
        ],
      ),
    );
  });
}
