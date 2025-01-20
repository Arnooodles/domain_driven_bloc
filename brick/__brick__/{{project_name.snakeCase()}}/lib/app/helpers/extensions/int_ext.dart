import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';

extension IntExt on int {
  StatusCode get statusCode => StatusCode.values.firstWhere(
        (StatusCode element) => element.value == this,
        orElse: () => StatusCode.http000,
      );
}
