import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/constants/route_name.dart';
import 'package:very_good_core/app/helpers/injection.dart';
import 'package:very_good_core/app/observers/go_route_observer.dart';
import 'package:very_good_core/app/routes/app_routes.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

@injectable
class AppRouter {
  AppRouter(@factoryParam this.authBloc);

  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');
  final ValueKey<String> scaffoldKey = const ValueKey<String>('scaffold');
  final AuthBloc authBloc;

  late final GoRouter router = GoRouter(
    routes:
        getIt<AppRoutes>(param1: shellNavigatorKey, param2: scaffoldKey).routes,
    redirect: _routeGuard,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: RouteName.initial.path,
    observers: <NavigatorObserver>[getIt<GoRouteObserver>()],
    navigatorKey: rootNavigatorKey,
  );

  String? _routeGuard(_, GoRouterState goRouterState) {
    final String loginPath = RouteName.login.path;
    final String initialPath = RouteName.initial.path;
    final String homePath = RouteName.home.path;

    return authBloc.state.mapOrNull(
      initial: (_) => initialPath,
      unauthenticated: (_) => loginPath,
      authenticated: (_) {
        // Check if the app is in the login screen
        final bool isLoginScreen = goRouterState.subloc == loginPath;
        final bool isSplashScreen = goRouterState.subloc == initialPath;

        // Go to home screen if the app is authenticated but tries to go to login
        // screen or is still in the splash screen.
        return isLoginScreen || isSplashScreen ? homePath : null;
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
