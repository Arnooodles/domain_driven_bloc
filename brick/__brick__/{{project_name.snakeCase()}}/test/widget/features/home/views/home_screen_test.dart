import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/route_name.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/views/home_screen.dart';

import '../../../../utils/golden_test_device_scenario.dart';
import '../../../../utils/mock_go_router_provider.dart';
import '../../../../utils/mock_material_app.dart';
import '../../../../utils/test_utils.dart';
import 'home_screen_test.mocks.dart';

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<AuthBloc>(),
    MockSpec<PostBloc>(),
    MockSpec<AppCoreBloc>(),
    MockSpec<GoRouterDelegate>(),
    MockSpec<GoRouter>(),
    MockSpec<StatefulNavigationShell>(),
    MockSpec<RouteMatchList>(),
  ],
)
void main() {
  late MockAuthBloc authBloc;
  late MockPostBloc postBloc;
  late MockAppCoreBloc appCoreBloc;
  late MockGoRouter router;
  late MockGoRouterDelegate routerDelegate;
  late MockRouteMatchList currentConfiguration;

  late MockStatefulNavigationShell navigationShell;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    authBloc = MockAuthBloc();
    postBloc = MockPostBloc();
    appCoreBloc = MockAppCoreBloc();
    scrollControllers = mockScrollControllers;
    final AuthState authState = AuthState.authenticated(user: mockUser);
    when(authBloc.stream).thenAnswer(
      (_) => Stream<AuthState>.fromIterable(<AuthState>[authState]),
    );
    when(authBloc.state).thenReturn(authState);
    when(appCoreBloc.stream).thenAnswer(
      (_) => Stream<AppCoreState>.fromIterable(
        <AppCoreState>[
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
        ],
      ),
    );
    when(appCoreBloc.state).thenReturn(
      AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
    );
  });

  MockGoRouter setUpRouter(String path, int index) {
    router = MockGoRouter();
    routerDelegate = MockGoRouterDelegate();
    navigationShell = MockStatefulNavigationShell();
    currentConfiguration = MockRouteMatchList();
    when(currentConfiguration.uri).thenAnswer((_) => Uri(path: path));
    when(routerDelegate.currentConfiguration)
        .thenAnswer((_) => currentConfiguration);
    when(router.routerDelegate).thenAnswer((_) => routerDelegate);
    when(navigationShell.currentIndex).thenAnswer((_) => index);
    return router;
  }

  PostBloc setUpPostBloc(Stream<PostState> stream, PostState state) {
    postBloc = MockPostBloc();

    if (getIt.isRegistered<PostBloc>()) {
      getIt
        ..unregister<PostBloc>()
        ..registerFactory<PostBloc>(() => postBloc);
    } else {
      getIt.registerFactory<PostBloc>(() => postBloc);
    }
    when(postBloc.stream).thenAnswer(
      (_) => stream,
    );

    when(postBloc.state).thenReturn(state);
    return postBloc;
  }

  Widget buildHomeScreen(PostBloc postBloc) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<PostBloc>(
            create: (BuildContext context) => postBloc,
          ),
          BlocProvider<AppCoreBloc>(
            create: (BuildContext context) => appCoreBloc,
          ),
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => authBloc,
          ),
        ],
        child: MockMaterialApp(
          child: MockGoRouterProvider(
            router: setUpRouter(RouteName.home.path, 0),
            child: const Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );

  group('Home Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'home_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 5));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'initial',
            builder: () => buildHomeScreen(
              setUpPostBloc(
                Stream<PostState>.fromIterable(
                  <PostState>[const PostState.loading()],
                ),
                const PostState.loading(),
              ),
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'with posts',
            builder: () => buildHomeScreen(
              setUpPostBloc(
                Stream<PostState>.fromIterable(
                  <PostState>[
                    PostState.success(mockPosts),
                  ],
                ),
                PostState.success(mockPosts),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
