import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';

extension StatusCodeExt on StatusCode {
  bool get isSuccess => value == 200 || value == 201 || value == 204;
}
