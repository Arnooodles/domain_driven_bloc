import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';

// ignore_for_file: prefer-match-file-name
class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation.drive(_curveTween),
            child: child,
          ),
        );

  static final CurveTween _curveTween = CurveTween(curve: Curves.ease);
}

class SlideTransitionPage extends CustomTransitionPage<void> {
  SlideTransitionPage({
    required LocalKey super.key,
    required super.child,
    this.transitionType = SlideTransitionType.bottomToTop,
  }) : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: animation.drive(
              getOffset(transitionType),
            ),
            child: child,
          ),
        );
  final SlideTransitionType transitionType;

  static Animatable<Offset> getOffset(SlideTransitionType slideTransitionType) {
    switch (slideTransitionType) {
      case SlideTransitionType.topToBottom:
        return _getTween(const Offset(0, -1));
      case SlideTransitionType.bottomToTop:
        return _getTween(const Offset(0, 1));
      case SlideTransitionType.leftToRight:
        return _getTween(const Offset(-1, 0));
      case SlideTransitionType.rightToLeft:
        return _getTween(const Offset(1, 0));
    }
  }

  static Animatable<Offset> _getTween(Offset begin) =>
      Tween<Offset>(begin: begin, end: Offset.zero)
          .chain(CurveTween(curve: Curves.ease));
}
