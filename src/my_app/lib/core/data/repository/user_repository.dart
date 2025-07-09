import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/int_ext.dart';
import 'package:very_good_core/app/helpers/extensions/status_code_ext.dart';
import 'package:very_good_core/core/data/dto/user.dto.dart';
import 'package:very_good_core/core/data/service/user_service.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/core/domain/interface/i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  UserRepository(this._userService);

  final UserService _userService;

  @override
  Future<Either<Failure, User>> get user async {
    try {
      final Response<UserDTO> response = await _userService.getCurrentUser();

      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null) {
        return _validateUserData(response.body!);
      }

      return left(Failure.serverError(statusCode, response.error.toString()));
    } on Exception catch (error) {
      log(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  Either<Failure, User> _validateUserData(UserDTO userDTO) {
    final User user = userDTO.toDomain();

    return user.failureOption.fold(() => right(user), left);
  }
}
