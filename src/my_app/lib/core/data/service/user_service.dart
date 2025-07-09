import 'package:chopper/chopper.dart';
import 'package:very_good_core/core/data/dto/user.dto.dart';

part 'user_service.chopper.dart';

@ChopperApi(baseUrl: 'https://dummyjson.com/auth')
abstract interface class UserService extends ChopperService {
  @GET(path: '/me')
  Future<Response<UserDTO>> getCurrentUser();

  static UserService create() => _$UserService();
}
