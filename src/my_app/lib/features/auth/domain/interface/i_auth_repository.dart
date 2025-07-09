import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, Unit>> login(ValueString username, Password password);

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> refreshToken();
}
