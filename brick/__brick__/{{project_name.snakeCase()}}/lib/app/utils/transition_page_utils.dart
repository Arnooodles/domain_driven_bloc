import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/slide_transition_type.dart';

// ignore_for_file: prefer-match-file-name
final class FadeTransitionPage extends CustomTransitionPage<void> {
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

final class SlideTransitionPage extends CustomTransitionPage<void> {
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

  static Animatable<Offset> getOffset(
    SlideTransitionType slideTransitionType,
  ) =>
      switch (slideTransitionType) {
        SlideTransitionType.topToBottom => _getTween(const Offset(0, -1)),
        SlideTransitionType.bottomToTop => _getTween(const Offset(0, 1)),
        SlideTransitionType.leftToRight => _getTween(const Offset(-1, 0)),
        SlideTransitionType.rightToLeft => _getTween(const Offset(1, 0)),
      };

  static Animatable<Offset> _getTween(Offset begin) =>
      Tween<Offset>(begin: begin, end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOut));
}
