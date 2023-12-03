import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';

extension StatusCodeExt on StatusCode {
  bool get isSuccess => value == 200 || value == 201 || value == 204;
}
