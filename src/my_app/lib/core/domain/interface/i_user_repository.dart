import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/model/failure.dart';
import 'package:very_good_core/core/domain/model/user.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, User>> get user;
}
