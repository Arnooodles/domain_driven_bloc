// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter/services.dart';
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
  /// Returns TRUE when [onError] is NOT called.
  Future<bool> safeRun({
    required FutureOr<void> Function() action,
    required ValueChanged<Exception> onError,
    ValueChanged<bool>? onLoading,
  }) async {
    try {
      onLoading?.call(true);

      final FutureOr<void> result = action();

      if (result is Future) {
        await result;
      }
      return true;
    } on Exception catch (e) {
      onError.call(e);
      return false;
    } finally {
      onLoading?.call(false);
    }
  }
}
