import 'package:dartz/dartz.dart';
import 'package:my_app/core/domain/model/user.dart';

abstract class IUserRepository {
  Future<Option<User>> get user;
}
