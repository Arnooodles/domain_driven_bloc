import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/route.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/model/failures.dart';
import 'package:very_good_core/core/presentation/screens/main_screen.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:very_good_core/features/home/presentation/screens/home_screen.dart';
import 'package:very_good_core/features/profile/presentation/screens/profile_screen.dart';

import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/mock_material_app.dart';
import '../../../utils/test_utils.dart';
import 'main_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthBloc>(),
  MockSpec<AppCoreBloc>(),
  MockSpec<GoRouter>(),
])
void main() {
  late MockAuthBloc authBloc;
  late MockAuthBloc authBlocError;
  late MockAuthBloc authBlocLoading;
  late MockAppCoreBloc appCoreBloc;
  late MockGoRouter routerHome;
  late MockGoRouter routerProfile;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    authBloc = MockAuthBloc();
    authBlocError = MockAuthBloc();
    authBlocLoading = MockAuthBloc();
    appCoreBloc = MockAppCoreBloc();
    routerHome = MockGoRouter();
    routerProfile = MockGoRouter();
    final AuthState authState = AuthState.initial().copyWith(
      status: AuthStatus.authenticated,
      user: mockUser,
      isLoading: false,
    );
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
        authState.copyWith(
          failure: const Failure.unexpected('Unexpected Error'),
        ),
      ]),
    );
    when(authBlocError.state).thenAnswer(
      (_) => authState.copyWith(
        failure: const Failure.unexpected('Unexpected Error'),
      ),
    );

    when(authBlocLoading.stream).thenAnswer(
      (_) => Stream<AuthState>.fromIterable(<AuthState>[
        authState.copyWith(isLoading: true, user: null, failure: null),
      ]),
    );
    when(authBlocLoading.state).thenAnswer(
      (_) => authState.copyWith(isLoading: true, user: null, failure: null),
    );

    when(routerHome.location).thenAnswer((_) => RouteName.home.path);
    when(routerHome.canPop()).thenAnswer((_) => false);

    when(routerProfile.location).thenAnswer((_) => RouteName.profile.path);
    when(routerProfile.canPop()).thenAnswer((_) => false);
  });

  Widget buildVeryGoodCoreScreen(
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

  group('VeryGoodCore Screen Tests', () {
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
            builder: () => buildVeryGoodCoreScreen(
              const HomeScreen(),
              routerHome,
              authBloc,
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'profile',
            builder: () => buildVeryGoodCoreScreen(
              const ProfileScreen(),
              routerProfile,
              authBloc,
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'error',
            builder: () => buildVeryGoodCoreScreen(
              const HomeScreen(),
              routerHome,
              authBlocError,
            ),
          ),
        ],
      ),
    );
    // goldenTest(
    //   'renders correctly',
    //   fileName: 'main_screen_loading'.goldensVersion,
    //   pumpBeforeTest: (WidgetTester tester) async {
    //     await tester.pump(const Duration(seconds: 1));
    //   },
    //   builder: () => GoldenTestGroup(
    //     children: <Widget>[
    //       GoldenTestDeviceScenario(
    //         name: 'loading',
    //         builder: () => buildVeryGoodCoreScreen(
    //           const HomeScreen(),
    //           routerHome,
    //           authBlocLoading,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  });
}
