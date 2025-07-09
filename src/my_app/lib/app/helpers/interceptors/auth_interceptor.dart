import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/features/auth/domain/interface/i_auth_repository.dart';

@Singleton(order: -1)
class AuthInterceptor implements Interceptor {
  const AuthInterceptor();

  static const String _dummyJsonHost = 'dummyjson.com';
  static const String _refreshPath = '/refresh';
  static const String _authorizationHeader = 'Authorization';
  static const int _unauthorizedStatusCode = 401;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final Request request = chain.request;

    // Skip interceptor for non-dummyjson requests or refresh requests
    if (!_shouldIntercept(request)) {
      return await chain.proceed(request);
    }

    return await _handleAuthenticatedRequest(chain);
  }

  bool _shouldIntercept(Request request) =>
      request.uri.host.contains(_dummyJsonHost) && !request.uri.path.contains(_refreshPath);

  Future<Response<BodyType>> _handleAuthenticatedRequest<BodyType>(Chain<BodyType> chain) async {
    final String? token = await _getAccessToken();
    if (token == null) {
      return await chain.proceed(chain.request);
    }

    final Request authenticatedRequest = _addAuthorizationHeader(chain.request, token);
    final Response<BodyType> response = await chain.proceed(authenticatedRequest);

    if (response.statusCode == _unauthorizedStatusCode) {
      return _handleUnauthorizedResponse(chain, authenticatedRequest);
    }

    return response;
  }

  Future<String?> _getAccessToken() async => getIt<ILocalStorageRepository>().getAccessToken();

  Request _addAuthorizationHeader(Request request, String token) =>
      applyHeader(request, _authorizationHeader, 'Bearer $token');

  Future<Response<BodyType>> _handleUnauthorizedResponse<BodyType>(
    Chain<BodyType> chain,
    Request originalRequest,
  ) async {
    final Either<Failure, Unit> refreshResult = await getIt<IAuthRepository>().refreshToken();

    if (refreshResult.isLeft()) {
      throw Exception('Token refresh failed: ${refreshResult.asLeft()}');
    }

    final String? newToken = await _getAccessToken();
    if (newToken == null) {
      return await chain.proceed(originalRequest);
    }

    final Request newRequest = _addAuthorizationHeader(chain.request, newToken);
    return await chain.proceed(newRequest);
  }
}
