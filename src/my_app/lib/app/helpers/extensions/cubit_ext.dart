import 'package:flutter_bloc/flutter_bloc.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member,invalid_use_of_protected_member
extension CubitExt<S> on Cubit<S> {
  void safeEmit(S state) {
    if (isClosed) return;
    emit(state);
  }
}
