import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/observers/go_route_observer.dart';
import 'package:very_good_core/app/routes/app_routes.dart';
import 'package:very_good_core/app/routes/route_guard.dart';
import 'package:very_good_core/app/routes/route_name.dart';
import 'package:very_good_core/app/routes/route_navigator_keys.dart';
import 'package:very_good_core/app/routes/route_refresh_listener.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    routes: AppRoutes.routes,
    redirect: getIt<RouteGuard>().guard,
    refreshListenable: getIt<RouteRefreshListener>(),
    initialLocation: RouteName.initial.path,
    observers: <NavigatorObserver>[getIt<GoRouteObserver>(param1: RouteNavigatorKeys.debugLabel)],
    navigatorKey: RouteNavigatorKeys.root,
  );
}
