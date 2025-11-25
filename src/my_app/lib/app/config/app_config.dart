import 'package:envied/envied.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:very_good_core/core/domain/entity/enum/env.dart';

part 'app_config.g.dart';

final class AppConfig {
  static final AppEnv _envConfig = switch (Env.fromFlavor(isWeb: kIsWeb)) {
    Env.development => _DevelopmentEnv(),
    Env.staging => _StagingEnv(),
    Env.production => _ProductionEnv(),
    _ => throw Exception('Unknown environment'),
  };

  static Env get environment => switch (_envConfig.env.toLowerCase()) {
    'development' => Env.development,
    'staging' => Env.staging,
    'production' => Env.production,
    _ => throw Exception('Unknown environment'),
  };

  static String get apiKey => _envConfig.apiKey;
}

@Envied(path: 'assets/env/.env.production', name: 'ProductionEnv', useConstantCase: true)
@Envied(path: 'assets/env/.env.development', name: 'DevelopmentEnv', useConstantCase: true)
@Envied(path: 'assets/env/.env.staging', name: 'StagingEnv', useConstantCase: true)
abstract class AppEnv {
  @EnviedField(varName: 'ENV')
  abstract final String env;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  abstract final String apiKey;
}
