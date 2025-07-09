import 'package:chopper/chopper.dart';
import 'package:very_good_core/features/auth/data/dto/login_response.dto.dart';

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: 'https://dummyjson.com/auth')
abstract interface class AuthService extends ChopperService {
  @POST(path: '/login')
  Future<Response<LoginResponseDTO>> login(@Body() Map<String, dynamic> loginCredentials);

  @POST(path: '/logout', optionalBody: true)
  Future<Response<dynamic>> logout();

  @POST(path: '/refresh')
  Future<Response<LoginResponseDTO>> refreshToken(@Body() Map<String, dynamic> refreshCredentials);

  static AuthService create() => _$AuthService();
}
