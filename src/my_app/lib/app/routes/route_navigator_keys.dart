import 'package:flutter/widgets.dart';

abstract final class RouteNavigatorKeys {
  const RouteNavigatorKeys._();

  static const String debugLabel = 'root';
  static GlobalKey<NavigatorState> root =
      GlobalKey<NavigatorState>(debugLabel: debugLabel);
}
