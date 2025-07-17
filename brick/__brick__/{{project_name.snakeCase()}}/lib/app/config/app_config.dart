import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/env.dart';

final class AppConfig {
  static Env get environment => switch (dotenv.get('ENV')) {
    'Development' => Env.development,
    'Staging' => Env.staging,
    'Production' => Env.production,
    _ => Env.development,
  };
}
