import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';

abstract interface class IAuthRepository {
  Future<Result<Unit>> login(LoginRequest loginRequest);

  Future<Result<Unit>> logout();

  Future<Result<Unit>> refreshToken();
}
