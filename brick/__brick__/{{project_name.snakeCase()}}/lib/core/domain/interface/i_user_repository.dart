import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, User>> get user;
}
