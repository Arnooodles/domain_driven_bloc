import 'package:chopper/chopper.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/int_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/status_code_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/data/dto/user.dto.dart';
import 'package:{{project_name.snakeCase()}}/core/data/service/user_service.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/status_code.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  UserRepository(this._userService, this._talker);

  final UserService _userService;
  final Talker _talker;

  @override
  TaskResult<User> get user => TaskResult<User>.tryCatch(
    () async {
      final Response<UserDTO> response = await _userService.getCurrentUser();

      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null) {
        return _validateUserData(response.body!).getOrElse((Failure failure) => throw failure);
      } else {
        throw Failure.server(statusCode, response.error.toString());
      }
    },
    (Object error, StackTrace stackTrace) {
      _talker.handle(error, stackTrace);
      if (error is Failure) return error;
      return Failure.unexpected(error.toString());
    },
  );

  Result<User> _validateUserData(UserDTO userDTO) {
    final User user = userDTO.toDomain();

    return user.validate.fold(() => right(user), left);
  }
}
