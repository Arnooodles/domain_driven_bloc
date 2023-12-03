import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection.dart';

// ignore_for_file: avoid_dynamic_calls
@singleton
final class AppBlocObserver extends BlocObserver {
  Logger logger = getIt<Logger>();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.t('onChange(${bloc.runtimeType}, ${change.nextState.runtimeType})');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.e('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
