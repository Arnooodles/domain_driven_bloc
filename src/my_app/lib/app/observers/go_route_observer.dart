import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:very_good_core/app/helpers/injection.dart';

@injectable
final class GoRouteObserver extends NavigatorObserver {
  GoRouteObserver(
    @factoryParam this.navigatorLocation,
  );

  final String navigatorLocation;
  Logger logger = getIt<Logger>();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.t(
      '$navigatorLocation:${route.settings.name} pushed from ${previousRoute?.settings.name}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.t(
      '$navigatorLocation:${route.settings.name} popped from ${previousRoute?.settings.name}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.t(
      '$navigatorLocation:${route.settings.name} removed ${previousRoute?.settings.name}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logger.t(
      '${newRoute?.settings.name} replaced ${oldRoute?.settings.name}',
    );
  }
}
