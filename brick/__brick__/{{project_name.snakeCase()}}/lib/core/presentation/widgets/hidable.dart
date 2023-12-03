import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/hidable/hidable_bloc.dart';

class Hidable extends StatelessWidget {
  const Hidable({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocBuilder<HidableBloc, bool>(
        builder: (BuildContext context, bool isVisible) => AnimatedAlign(
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 500),
          heightFactor: isVisible ? 1.0 : 0.0,
          child: child,
        ),
      );
}
