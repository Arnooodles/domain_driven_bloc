import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, Unit>> login(EmailAddress email, Password password);

  Future<Either<Failure, Unit>> logout();
}
