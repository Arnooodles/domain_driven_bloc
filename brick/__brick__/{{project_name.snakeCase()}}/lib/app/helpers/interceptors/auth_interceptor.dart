import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:dartx/dartx.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/fpdart_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';

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
    final Either<Failure, String> possibleFailure = await _getAccessToken();

    return possibleFailure.fold(
      (Failure failure) {
        throw Exception(failure.message);
      },
      (String token) async {
        final Request authenticatedRequest = _addAuthorizationHeader(chain.request, token);
        final Response<BodyType> response = await chain.proceed(authenticatedRequest);

        if (response.statusCode == _unauthorizedStatusCode) {
          return _handleUnauthorizedResponse(chain, authenticatedRequest);
        }

        return response;
      },
    );
  }

  Future<Either<Failure, String>> _getAccessToken() async {
    final Either<Failure, String?> possibleFailure = await getIt<ILocalStorageRepository>().getAccessToken();
    return possibleFailure.fold(
      left,
      (String? value) =>
          value.isNotNullOrBlank ? right(value!) : left(const Failure.authentication('Access token not found')),
    );
  }

  Request _addAuthorizationHeader(Request request, String token) =>
      applyHeader(request, _authorizationHeader, 'Bearer $token');

  Future<Response<BodyType>> _handleUnauthorizedResponse<BodyType>(
    Chain<BodyType> chain,
    Request originalRequest,
  ) async {
    final Either<Failure, Unit> refreshResult = await getIt<IAuthRepository>().refreshToken();

    if (refreshResult.isLeft()) {
      final Failure failure = refreshResult.asLeft();
      throw Exception('Token refresh failed: ${failure.message}');
    }

    final Either<Failure, String> tokenResult = await _getAccessToken();

    if (tokenResult.isLeft()) {
      final Failure failure = tokenResult.asLeft();
      throw Exception(failure.message);
    }

    final String newToken = tokenResult.asRight();
    final Request newRequest = _addAuthorizationHeader(originalRequest, newToken);
    return await chain.proceed(newRequest);
  }
}
