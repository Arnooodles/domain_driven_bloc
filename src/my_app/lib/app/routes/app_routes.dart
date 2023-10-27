part of 'app_router.dart';

//ignore_for_file: long-method
List<RouteBase> _getRoutes(GlobalKey<NavigatorState> rootNavigatorKey) =>
    <RouteBase>[
      GoRoute(
        path: RouteName.initial.path,
        name: RouteName.initial.name,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: RouteName.login.path,
        name: RouteName.login.name,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) =>
            MainScreen(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          // The route branch for the first tab of the bottom navigation bar.
          StatefulShellBranch(
            observers: <NavigatorObserver>[
              getIt<GoRouteObserver>(param1: 'app'),
            ],
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.home.path,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: RouteName.postDetails.path,
                    name: RouteName.postDetails.name,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final Post post = state.extra! as Post;
                      return SlideTransitionPage(
                        key: state.pageKey,
                        transitionType: SlideTransitionType.rightToLeft,
                        child: PostDetailsWebview(post: post),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // The route branch for the second tab of the bottom navigation bar.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.profile.path,
                name: RouteName.profile.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ];
