import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/auth/domain/entity/login_request.dart';

abstract interface class IAuthRepository {
  Future<Result<Unit>> login(LoginRequest loginRequest);

  Future<Result<Unit>> logout();

  Future<Result<Unit>> refreshToken();
}
