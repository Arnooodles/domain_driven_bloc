import 'package:flutter/services.dart';

enum Env {
  development('development'),
  staging('staging'),
  production('production'),
  test('test');

  const Env(this.value);

  factory Env.fromFlavor({required bool isWeb}) {
    final String? flavor = isWeb ? const String.fromEnvironment('flavor') : appFlavor;
    return switch (flavor) {
      'production' => Env.production,
      'development' => Env.development,
      'staging' => Env.staging,
      _ => throw UnsupportedError('Not supported flavor: $appFlavor'),
    };
  }

  final String value;
}
