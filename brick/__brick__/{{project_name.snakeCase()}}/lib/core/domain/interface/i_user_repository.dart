import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';

abstract interface class IUserRepository {
  TaskResult<User> get user;
}
