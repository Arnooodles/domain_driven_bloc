import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/auth/domain/entity/login_request.dart';

abstract interface class IAuthRepository {
  TaskResult<Unit> login(LoginRequest loginRequest);

  TaskResult<Unit> logout();

  TaskResult<Unit> refreshToken();
}
