import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';
import 'package:very_good_core/app/config/app_config.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/trusted_cetificate.dart';
import 'package:very_good_core/app/helpers/converters/json_serializable_converter.dart';
import 'package:very_good_core/core/data/model/user.dto.dart';
import 'package:very_good_core/core/data/service/user_service.dart';
import 'package:very_good_core/features/auth/data/model/login_response.dto.dart';
import 'package:very_good_core/features/auth/data/service/auth_service.dart';
import 'package:very_good_core/features/home/data/model/post.dto.dart';
import 'package:very_good_core/features/home/data/service/post_service.dart';

final class ChopperConfig {
  final Uri _baseUrl = Uri.parse(AppConfig.baseApiUrl);

  final List<ChopperService> _services = <ChopperService>[
    AuthService.create(),
    UserService.create(),
    PostService.create(),
  ];

  final JsonSerializableConverter _converter = const JsonSerializableConverter(
    <Type, dynamic Function(Map<String, dynamic>)>{
      LoginResponseDTO: LoginResponseDTO.fromJson,
      UserDTO: UserDTO.fromJson,
      PostDTO: PostDTO.fromJson,
    },
  );

  final List<dynamic> _interceptors = <dynamic>[
    (Request request) async {
      // TODO: added interceptor to accommodate multiple api host
      if (request.uri.path.contains('FlutterDev.json')) {
        return request.copyWith(
          baseUri: Uri(scheme: 'https', host: 'reddit.com'),
        );
      }

      // TODO: uncomment if the API requires Authorization
      //final String? accessToken = await getIt<ILocalStorageRepository>()
      //.getAccessToken();

      final Map<String, String> headers = <String, String>{}
        ..addEntries(request.headers.entries)
        ..putIfAbsent('Accept', () => 'application/json')
        ..putIfAbsent('Content-type', () => 'application/json');
      // TODO: uncomment if the API requires Authorization
      //..putIfAbsent('Authorization', () => 'Bearer $accessToken');

      return request.copyWith(headers: headers);
    },
    if (kDebugMode) PrettyChopperLogger(),
    if (kDebugMode) CurlInterceptor(),
  ];

  /// SSL Pinning
  IOClient? get _securedClient => !kIsWeb
      ? IOClient(
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) {
              if (AppConfig.environment == Env.staging ||
                  AppConfig.environment == Env.production) {
                final String hash =
                    sha256.convert(cert.pem.codeUnits).toString();
                return TrustedCertificate.values
                    .map((TrustedCertificate e) => e.value)
                    .toList()
                    .contains(hash);
              }
              return true;
            },
        )
      : null;

  ChopperClient get client => ChopperClient(
        baseUrl: _baseUrl,
        client: _securedClient,
        interceptors: _interceptors,
        converter: _converter,
        services: _services,
      );
}
