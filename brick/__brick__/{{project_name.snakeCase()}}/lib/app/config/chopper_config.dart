import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_chopper_logger/talker_chopper_logger_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/app/config/app_config.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/trusted_cetificate.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/converters/json_serializable_converter.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/interceptors/auth_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/core/data/dto/user.dto.dart';
import 'package:{{project_name.snakeCase()}}/core/data/service/user_service.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/env.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/dto/login_response.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/service/auth_service.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/dto/post.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/dto/post_list.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/service/post_service.dart';

@Singleton(order: -1)
final class ChopperConfig {
  ChopperConfig(this._authInterceptor);

  final AuthInterceptor _authInterceptor;

  static const int sessionTimeout = 30; // in minutes

  final List<ChopperService> _services = <ChopperService>[
    AuthService.create(),
    UserService.create(),
    PostService.create(),
  ];

  JsonSerializableConverter get converter => const JsonSerializableConverter(<Type, dynamic Function(Json)>{
    LoginResponseDTO: LoginResponseDTO.fromJson,
    UserDTO: UserDTO.fromJson,
    PostDTO: PostDTO.fromJson,
    PostReactionsDTO: PostReactionsDTO.fromJson,
    PostListDTO: PostListDTO.fromJson,
  });

  List<Interceptor> get _interceptors => <Interceptor>[
    const HeadersInterceptor(<String, String>{'Accept': 'application/json', 'Content-type': 'application/json'}),
    _authInterceptor,
    if (kDebugMode) getIt<TalkerChopperLogger>(),
  ];

  /// SSL Pinning
  IOClient? get _securedClient => !kIsWeb
      ? IOClient(
          HttpClient()
            ..badCertificateCallback = (X509Certificate cert, String host, int port) {
              if (AppConfig.environment == Env.staging || AppConfig.environment == Env.production) {
                final String hash = sha256.convert(cert.pem.codeUnits).toString();
                return TrustedCertificate.values.map((TrustedCertificate e) => e.value).toList().contains(hash);
              }
              return true;
            },
        )
      : null;

  late final ChopperClient client = ChopperClient(
    baseUrl: Uri.parse(Constant.baseUrl),
    client: _securedClient,
    interceptors: _interceptors,
    converter: converter,
    errorConverter: converter,
    services: _services,
  );
}
