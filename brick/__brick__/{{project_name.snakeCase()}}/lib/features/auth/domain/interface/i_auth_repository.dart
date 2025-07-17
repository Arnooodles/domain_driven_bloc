import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/entity/login_request.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, Unit>> login(LoginRequest loginRequest);

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> refreshToken();
}
