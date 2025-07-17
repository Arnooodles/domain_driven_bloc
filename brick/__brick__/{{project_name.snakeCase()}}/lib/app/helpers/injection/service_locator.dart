import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.config.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/env.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies(Env env) => getIt.init(environment: env.name);
