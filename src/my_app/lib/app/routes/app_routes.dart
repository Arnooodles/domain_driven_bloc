import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/observers/go_route_observer.dart';
import 'package:very_good_core/app/routes/route_name.dart';
import 'package:very_good_core/app/routes/route_navigator_keys.dart';
import 'package:very_good_core/app/utils/transition_page_utils.dart';
import 'package:very_good_core/core/domain/entity/enum/slide_transition_type.dart';
import 'package:very_good_core/core/presentation/views/main_screen.dart';
import 'package:very_good_core/core/presentation/views/splash_screen.dart';
import 'package:very_good_core/features/auth/presentation/views/login_screen.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';
import 'package:very_good_core/features/home/presentation/views/home_screen.dart';
import 'package:very_good_core/features/home/presentation/views/post_details_screen.dart';
import 'package:very_good_core/features/profile/presentation/views/profile_screen.dart';

abstract final class AppRoutes {
  static List<RouteBase> get routes => <RouteBase>[
    GoRoute(
      path: RouteName.initial.path,
      name: RouteName.initial.name,
      builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteName.login.path,
      name: RouteName.login.name,
      builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) =>
          MainScreen(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        // The route branch for the first tab of the bottom navigation bar.
        StatefulShellBranch(
          observers: <NavigatorObserver>[getIt<GoRouteObserver>(param1: RouteName.home.name)],
          routes: <RouteBase>[
            GoRoute(
              path: RouteName.home.path,
              name: RouteName.home.name,
              builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: RouteName.postDetails.path,
                  name: RouteName.postDetails.name,
                  parentNavigatorKey: RouteNavigatorKeys.root,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    final Post post = state.extra! as Post;
                    return SlideTransitionPage(
                      key: state.pageKey,
                      transitionType: SlideTransitionType.rightToLeft,
                      child: PostDetailsScreen(post: post),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // The route branch for the second tab of the bottom navigation bar.
        StatefulShellBranch(
          observers: <NavigatorObserver>[getIt<GoRouteObserver>(param1: RouteName.profile.name)],
          routes: <RouteBase>[
            GoRoute(
              path: RouteName.profile.path,
              name: RouteName.profile.name,
              builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ];
}
