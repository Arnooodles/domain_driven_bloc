import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';

abstract interface class IAuthRepository {
  TaskResult<Unit> login(LoginRequest loginRequest);

  TaskResult<Unit> logout();

  TaskResult<Unit> refreshToken();
}
