import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';

// ignore_for_file: avoid_dynamic_calls
@lazySingleton
final class AppBlocObserver extends BlocObserver {
  final Logger _logger = getIt<Logger>();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.t(
      'Current:${change.currentState}\nNext:${change.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.e('onError:\n${bloc.runtimeType}, $error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
