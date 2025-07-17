import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/features/auth/domain/entity/login_request.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, Unit>> login(LoginRequest loginRequest);

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> refreshToken();
}
