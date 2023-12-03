import 'package:go_router/go_router.dart';

extension GoRouterExt on GoRouter {
  String get location => routerDelegate.currentConfiguration.uri.toString();
}
