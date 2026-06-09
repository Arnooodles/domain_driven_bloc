// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension CubitExt<S> on Cubit<S> {
  void safeEmit(S state) {
    if (isClosed) return;
    emit(state);
  }

  /// Call [action] with exception handling.
  ///
  /// [onLoading] is only required if [action] is a [Future].
  ///
  /// Returns TRUE when [onException] is NOT called.
  Future<bool> safeRun({
    required FutureOr<void> Function() action,
    required void Function(Exception, StackTrace?) onException,
    ValueChanged<bool>? onLoading,
  }) async {
    try {
      onLoading?.call(true);

      final FutureOr<void> result = action();

      if (result is Future) {
        await result;
      }
      return true;
    } on Exception catch (error, stackTrace) {
      onException(error, stackTrace);
      return false;
    } finally {
      onLoading?.call(false);
    }
  }
}

extension BlocPresentationMixinExt<S, P> on BlocPresentationMixin<S, P> {
  void safeEmitPresentation(P event) {
    if (isClosed) return;
    emitPresentation(event);
  }
}
