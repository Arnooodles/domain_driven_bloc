import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

@lazySingleton
class RouteRefreshListener extends ChangeNotifier {
  RouteRefreshListener(this._authBloc) {
    notifyListeners();
    _authStreamSubscription = _authBloc.stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authStreamSubscription;

  @override
  void dispose() {
    _authStreamSubscription.cancel();
    super.dispose();
  }
}
