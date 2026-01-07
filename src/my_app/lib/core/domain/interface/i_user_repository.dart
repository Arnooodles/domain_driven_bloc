import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/core/domain/entity/user.dart';

abstract interface class IUserRepository {
  Future<Result<User>> get user;
}
