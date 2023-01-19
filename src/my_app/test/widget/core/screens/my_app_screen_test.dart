import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/app/constants/enum.dart';
import 'package:my_app/app/constants/route.dart';
import 'package:my_app/core/domain/bloc/my_app/my_app_bloc.dart';
import 'package:my_app/core/domain/model/failures.dart';
import 'package:my_app/core/presentation/screens/my_app_screen.dart';
import 'package:my_app/features/home/presentation/screens/home_screen.dart';
import 'package:my_app/features/profile/presentation/screens/profile_screen.dart';

import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/mock_material_app.dart';
import '../../../utils/test_utils.dart';
import 'my_app_screen_test.mocks.dart';

@GenerateMocks(<Type>[MyAppBloc, GoRouter])
void main() {
  late MockMyAppBloc myAppBloc;
  late MockMyAppBloc myAppBlocError;
  late MockMyAppBloc myAppBlocLoading;
  late MockGoRouter routerHome;
  late MockGoRouter routerProfile;

  setUp(() {
    myAppBloc = MockMyAppBloc();
    myAppBlocError = MockMyAppBloc();
    myAppBlocLoading = MockMyAppBloc();
    routerHome = MockGoRouter();
    routerProfile = MockGoRouter();
    final MyAppState state = MyAppState.initial().copyWith(
      authStatus: AuthStatus.authenticated,
      user: mockUser,
      isLoading: false,
    );

    when(myAppBloc.stream).thenAnswer(
      (_) => Stream<MyAppState>.fromIterable(<MyAppState>[state]),
    );
    when(myAppBloc.state).thenAnswer((_) => state);
    when(myAppBlocError.stream).thenAnswer(
      (_) => Stream<MyAppState>.fromIterable(<MyAppState>[
        state.copyWith(
          failure: const Failure.unexpected('Unexpected Error'),
        ),
      ]),
    );
    when(myAppBlocError.state).thenAnswer(
      (_) =>
          state.copyWith(failure: const Failure.unexpected('Unexpected Error')),
    );
    when(myAppBlocLoading.stream).thenAnswer(
      (_) => Stream<MyAppState>.fromIterable(<MyAppState>[
        state.copyWith(isLoading: true, user: null, failure: null),
      ]),
    );
    when(myAppBlocLoading.state).thenAnswer(
      (_) => state.copyWith(isLoading: true, user: null, failure: null),
    );
    when(routerHome.location).thenAnswer((_) => RouteName.home.path);
    when(routerProfile.location).thenAnswer((_) => RouteName.profile.path);
    when(routerProfile.canPop()).thenAnswer((_) => false);
    when(routerHome.canPop()).thenAnswer((_) => false);
  });

  Widget buildMyAppScreen(
    Widget child,
    GoRouter router,
    MyAppBloc myAppBloc,
  ) =>
      MockMaterialApp(
        child: MockGoRouterProvider(
          router: router,
          child: BlocProvider<MyAppBloc>(
            create: (BuildContext context) => myAppBloc,
            child: Scaffold(
              body: MyAppScreen(
                child: child,
              ),
            ),
          ),
        ),
      );

  group('MyApp Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'my_app_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pumpAndSettle(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'home',
            builder: () =>
                buildMyAppScreen(const HomeScreen(), routerHome, myAppBloc),
          ),
          GoldenTestDeviceScenario(
            name: 'profile',
            builder: () => buildMyAppScreen(
              const ProfileScreen(),
              routerProfile,
              myAppBloc,
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'error',
            builder: () => buildMyAppScreen(
              const HomeScreen(),
              routerHome,
              myAppBlocError,
            ),
          ),
        ],
      ),
    );
    goldenTest(
      'renders correctly',
      fileName: 'my_app_screen_loading'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'loading',
            builder: () => buildMyAppScreen(
              const HomeScreen(),
              routerHome,
              myAppBlocLoading,
            ),
          ),
        ],
      ),
    );
  });
}
