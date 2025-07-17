import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';

@injectable
final class GoRouteObserver extends NavigatorObserver {
  GoRouteObserver(@factoryParam this._navigatorLocation);

  final String _navigatorLocation;
  final Logger _logger = getIt<Logger>();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logNavigation(route.settings.name, previousRoute?.settings.name, _NavigatorActions.pushed);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logNavigation(route.settings.name, previousRoute?.settings.name, _NavigatorActions.popped);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logNavigation(route.settings.name, previousRoute?.settings.name, _NavigatorActions.removed);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logNavigation(newRoute?.settings.name, oldRoute?.settings.name, _NavigatorActions.replaced);
  }

  void _logNavigation(String? newRoute, String? oldRoute, _NavigatorActions action) {
    if (newRoute.isNotNullOrBlank && oldRoute.isNotNullOrBlank) {
      _logger.t('$_navigatorLocation:$newRoute ${action.value} $oldRoute');
    }
  }
}

enum _NavigatorActions {
  pushed('pushed from'),
  popped('popped from'),
  removed('removed'),
  replaced('replaced');

  const _NavigatorActions(this.value);

  final String value;
}
