import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_core/core/domain/bloc/hidable/hidable_bloc.dart';

class Hidable extends StatelessWidget {
  const Hidable({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedAlign(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 500),
        heightFactor: context.watch<HidableBloc>().state ? 1.0 : 0.0,
        child: child,
      );
}
