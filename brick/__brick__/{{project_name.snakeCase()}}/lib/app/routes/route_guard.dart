import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/app_routes.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/cubit/auth/auth_cubit.dart';

@lazySingleton
final class RouteGuard {
  RouteGuard(this._authCubit);

  final AuthCubit _authCubit;

  String? guard(BuildContext context, GoRouterState goRouterState) => _authCubit.state.maybeWhen(
    initial: () => const SplashRoute().location,
    unauthenticated: () => const LoginRoute().location,
    authenticated: (_) => _authenticatedRouteGuard(goRouterState.matchedLocation),
    orElse: () => null,
  );

  String? _authenticatedRouteGuard(String matchedLocation) {
    // Check if the app is in the login screen or splash screen.
    final bool isLoginScreen = matchedLocation == const LoginRoute().location;
    final bool isSplashScreen = matchedLocation == const SplashRoute().location;

    // Go to home screen if the app is authenticated but tries to go to the
    // login screen or is still in the splash screen.
    return isLoginScreen || isSplashScreen ? const HomeRoute().location : null;
  }
}
