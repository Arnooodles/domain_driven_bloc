import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.config.dart';
import 'package:very_good_core/core/domain/entity/enum/env.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies(Env env) =>
    getIt.init(environment: env.name);
