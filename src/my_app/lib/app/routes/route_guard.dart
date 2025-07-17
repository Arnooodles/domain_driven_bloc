import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/routes/route_name.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

@lazySingleton
final class RouteGuard {
  RouteGuard(this._authBloc);

  final AuthBloc _authBloc;

  String? guard(BuildContext context, GoRouterState goRouterState) => _authBloc.state.maybeWhen(
    initial: () => RouteName.initial.path,
    unauthenticated: () => RouteName.login.path,
    authenticated: (_) => _authenticatedRouteGuard(goRouterState.matchedLocation),
    orElse: () => null,
  );

  String? _authenticatedRouteGuard(String matchedLocation) {
    // Check if the app is in the login screen
    final bool isLoginScreen = matchedLocation == RouteName.login.path;
    final bool isSplashScreen = matchedLocation == RouteName.initial.path;

    // Go to home screen if the app is authenticated but tries to go to login
    // screen or is still in the splash screen.
    return isLoginScreen || isSplashScreen ? RouteName.home.path : null;
  }
}
