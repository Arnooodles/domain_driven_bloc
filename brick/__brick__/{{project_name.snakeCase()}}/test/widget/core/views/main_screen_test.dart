void main() async {}

/// TODO(all) : https://stackoverflow.com/questions/77167466/how-to-create-a-widget-test-that-uses-go-routers-statefulnavigationshell

// import 'package:alchemist/alchemist.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
// import 'package:{{project_name.snakeCase()}}/app/constants/route_name.dart';
// import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
// import 'package:{{project_name.snakeCase()}}/core/presentation/views/main_screen.dart';
// import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
// import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';

// import '../../../utils/golden_test_device_scenario.dart';
// import '../../../utils/mock_go_router_provider.dart';
// import '../../../utils/mock_material_app.dart';
// import '../../../utils/test_utils.dart';
// import 'main_screen_test.mocks.dart';

// @GenerateNiceMocks(<MockSpec<dynamic>>[
//   MockSpec<AuthBloc>(),
//   MockSpec<AppCoreBloc>(),
//   MockSpec<PostBloc>(),
//   MockSpec<GoRouter>(),
//   MockSpec<GoRouterDelegate>(),
//   MockSpec<StatefulNavigationShell>(),
//   MockSpec<RouteMatchList>(),
// ])
// void main() {
//   late MockAuthBloc authBloc;
//   late MockAppCoreBloc appCoreBloc;
//   late MockStatefulNavigationShell navigationShell;
//   late MockGoRouter router;
//   late MockGoRouterDelegate routerDelegate;
//   late MockRouteMatchList currentConfiguration;

//   late Map<AppScrollController, ScrollController> scrollControllers;

//   setUp(() {
//     authBloc = MockAuthBloc();
//     appCoreBloc = MockAppCoreBloc();
//     router = MockGoRouter();
//     navigationShell = MockStatefulNavigationShell();

//     scrollControllers = <AppScrollController, ScrollController>{
//       AppScrollController.home: ScrollController(),
//       AppScrollController.profile: ScrollController(),
//     };

//     when(appCoreBloc.stream).thenAnswer(
//       (_) => Stream<AppCoreState>.fromIterable(
//         <AppCoreState>[
//           AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
//         ],
//       ),
//     );
//     when(appCoreBloc.state).thenAnswer(
//       (_) =>
//           AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
//     );
//     when(appCoreBloc.getScrollController(any))
//         .thenAnswer((_) => ScrollController());
//   });

//   AuthBloc setUpAuthBloc() {
//     authBloc = MockAuthBloc();
//     final AuthState authState = AuthState.authenticated(user: mockUser);
//     when(authBloc.stream).thenAnswer(
//       (_) => Stream<AuthState>.fromIterable(<AuthState>[authState]),
//     );
//     when(authBloc.state).thenAnswer((_) => authState);
//     return authBloc;
//   }

//   (MockGoRouter, MockStatefulNavigationShell) setUpRouter(
//     String path,
//     int index,
//   ) {
//     router = MockGoRouter();

//     routerDelegate = MockGoRouterDelegate();
//     navigationShell = MockStatefulNavigationShell();
//     currentConfiguration = MockRouteMatchList();
//     when(currentConfiguration.uri).thenAnswer((_) => Uri(path: path));
//     when(routerDelegate.currentConfiguration)
//         .thenAnswer((_) => currentConfiguration);
//     when(router.routerDelegate).thenAnswer((_) => routerDelegate);
//     when(navigationShell.currentIndex).thenAnswer((_) => index);

//     return (router, navigationShell);
//   }

//   Widget build{{#pascalCase}}{{project_name}}{{/pascalCase}}Screen(
//     (MockGoRouter, MockStatefulNavigationShell) goRouter,
//     AuthBloc authBloc,
//   ) =>
//       MockMaterialApp(
//         child: MockGoRouterProvider(
//           router: goRouter.$1,
//           child: MultiBlocProvider(
//             providers: <BlocProvider<dynamic>>[
//               BlocProvider<AuthBloc>(
//                 create: (BuildContext context) => authBloc,
//               ),
//               BlocProvider<AppCoreBloc>(
//                 create: (BuildContext context) => appCoreBloc,
//               ),
//             ],
//             child: MainScreen(
//               navigationShell: goRouter.$2,
//             ),
//           ),
//         ),
//       );

//   group('{{#pascalCase}}{{project_name}}{{/pascalCase}} Screen Tests', () {
//     goldenTest(
//       'renders correctly',
//       fileName: 'main_screen'.goldensVersion,
//       pumpBeforeTest: (WidgetTester tester) async {
//         await tester.pumpAndSettle(const Duration(seconds: 6));
//       },
//       builder: () => GoldenTestGroup(
//         children: <Widget>[
//           GoldenTestDeviceScenario(
//             name: 'home',
//             builder: () => build{{#pascalCase}}{{project_name}}{{/pascalCase}}Screen(
//               setUpRouter(RouteName.home.path, 0),
//               setUpAuthBloc(),
//             ),
//           ),
//           GoldenTestDeviceScenario(
//             name: 'profile',
//             builder: () => build{{#pascalCase}}{{project_name}}{{/pascalCase}}Screen(
//               setUpRouter(RouteName.profile.path, 1),
//               setUpAuthBloc(),
//             ),
//           ),
//         ],
//       ),
//     );
//   });
// }
