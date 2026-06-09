// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/route_navigator_keys.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/transition_page_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/slide_transition_type.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/views/main_screen.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/views/splash_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/views/login_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/views/home_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/views/post_details_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/profile/presentation/views/profile_screen.dart';

part 'app_routes.g.dart';

// ---------------------------------------------------------------------------
// Top-level typed route declarations consumed by go_router_builder.
// The generator produces:
//   • $appRoutes – the List<RouteBase> to pass to GoRouter(routes: …)
//   • go() / push() helpers via the generated $ClassName mixins
// ---------------------------------------------------------------------------

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashScreen();
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginScreen();
}

@TypedStatefulShellRoute<MainShellRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRoute>(
          path: '/home',
          routes: <TypedRoute<RouteData>>[TypedGoRoute<PostDetailsRoute>(path: ':postId')],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<ProfileRoute>(path: '/profile')],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) =>
      MainScreen(navigationShell: navigationShell);
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// Navigates to the post-details screen.
///
/// [postId] is carried in the URL path as `:postId`.
/// [Post] is passed as `$extra` since it is not URL-serialisable.
class PostDetailsRoute extends GoRouteData with $PostDetailsRoute {
  const PostDetailsRoute({required this.postId, required this.$extra});

  final String postId;

  final Post $extra;

  /// Push above the shell (full-screen) by using the root navigator key.
  static final GlobalKey<NavigatorState> $parentNavigatorKey = RouteNavigatorKeys.root;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => SlideTransitionPage(
    key: state.pageKey,
    transitionType: SlideTransitionType.rightToLeft,
    child: PostDetailsScreen(post: $extra),
  );
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileScreen();
}
