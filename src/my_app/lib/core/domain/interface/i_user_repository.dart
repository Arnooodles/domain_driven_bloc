import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/user.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, User>> get user;
}
