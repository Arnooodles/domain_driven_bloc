import 'package:chopper/chopper.dart';
import 'package:very_good_core/features/auth/data/dto/login_response.dto.dart';

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: 'api')
abstract interface class AuthService extends ChopperService {
  @Post(path: '/login')
  Future<Response<LoginResponseDTO>> login(
    @Body() Map<String, dynamic> loginCredentials,
  );

  @Post(path: '/logout', optionalBody: true)
  Future<Response<dynamic>> logout();

  static AuthService create() => _$AuthService();
}
