import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_core/core/domain/cubit/hidable/hidable_cubit.dart';

class Hidable extends StatelessWidget {
  const Hidable({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedAlign(
    alignment: Alignment.topCenter,
    duration: const Duration(milliseconds: 500),
    heightFactor: context.watch<HidableCubit>().state ? 1.0 : 0.0,
    child: child,
  );
}
