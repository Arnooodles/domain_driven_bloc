import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:very_good_core/core/domain/entity/enum/env.dart';

final class AppConfig {
  AppConfig._();

  static Env? _environment;

  static Env get environment => _environment ??= switch (dotenv.get('ENV')) {
    'Development' => Env.development,
    'Staging' => Env.staging,
    'Production' => Env.production,
    _ => Env.test,
  };

  static set environment(Env value) {
    _environment = value;
  }

  static String get apiKey => dotenv.get('API_KEY', fallback: '');
}
