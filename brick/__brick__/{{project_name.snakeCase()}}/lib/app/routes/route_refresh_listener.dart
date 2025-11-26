import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/future_ext.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/cubit/auth/auth_cubit.dart';

@lazySingleton
class RouteRefreshListener extends ChangeNotifier {
  RouteRefreshListener(this._authCubit) {
    notifyListeners();
    _authStreamSubscription = _authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  final AuthCubit _authCubit;
  late final StreamSubscription<AuthState> _authStreamSubscription;

  @override
  void dispose() {
    unawaited(_authStreamSubscription.cancel().logOnError());
    super.dispose();
  }
}
