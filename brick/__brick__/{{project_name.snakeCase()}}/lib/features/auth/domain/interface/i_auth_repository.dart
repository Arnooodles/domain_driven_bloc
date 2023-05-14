import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/value_object.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, Unit>> login(EmailAddress email, Password password);

  Future<Either<Failure, Unit>> logout();
}
