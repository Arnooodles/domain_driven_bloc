import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/observers/go_route_observer.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/route_name.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/transition_page_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/views/main_screen.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/views/splash_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/views/login_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/views/home_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/views/post_details_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/profile/presentation/views/profile_screen.dart';

part 'app_routes.dart';

@injectable
final class AppRouter {
  AppRouter(this._authBloc);

  static const String debugLabel = 'root';
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: debugLabel);

  final AuthBloc _authBloc;

  late final GoRouter router = GoRouter(
    routes: _getRoutes(rootNavigatorKey),
    redirect: _routeGuard,
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    initialLocation: RouteName.initial.path,
    observers: <NavigatorObserver>[getIt<GoRouteObserver>(param1: debugLabel)],
    navigatorKey: rootNavigatorKey,
  );

  String? _routeGuard(_, GoRouterState goRouterState) {
    final String loginPath = RouteName.login.path;
    final String initialPath = RouteName.initial.path;
    final String homePath = RouteName.home.path;

    return _authBloc.state.whenOrNull(
      initial: () => initialPath,
      unauthenticated: () => loginPath,
      authenticated: (_) {
        // Check if the app is in the login screen
        final bool isLoginScreen = goRouterState.matchedLocation == loginPath;
        final bool isSplashScreen =
            goRouterState.matchedLocation == initialPath;

        // Go to home screen if the app is authenticated but tries to go to login
        // screen or is still in the splash screen.
        return isLoginScreen || isSplashScreen ? homePath : null;
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> auntStateStream) {
    notifyListeners();
    _authStreamSubscription = auntStateStream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _authStreamSubscription;

  @override
  void dispose() {
    _authStreamSubscription.cancel();
    super.dispose();
  }
}
