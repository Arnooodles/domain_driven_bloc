import 'dart:developer';

import 'package:chopper/chopper.dart' as chopper;
import 'package:dartx/dartx.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/app/helpers/extensions/int_ext.dart';
import 'package:very_good_core/app/helpers/extensions/status_code_ext.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/data/dto/post_list.dto.dart';
import 'package:very_good_core/features/home/data/service/post_service.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';
import 'package:very_good_core/features/home/domain/interface/i_post_repository.dart';

@LazySingleton(as: IPostRepository)
class PostRepository implements IPostRepository {
  PostRepository(this._postService, this._failureHandler);

  final PostService _postService;
  final FailureHandler _failureHandler;

  List<Post>? _cachedPosts;

  @override
  Future<Result<List<Post>>> getPosts({int skip = 0, int limit = 20, bool forceRefresh = false}) async {
    if (!forceRefresh && skip == 0 && _cachedPosts != null && _cachedPosts!.isNotEmpty) {
      return right(_cachedPosts!);
    }

    try {
      final chopper.Response<PostListDTO> response = await _postService.getPosts(skip: skip, limit: limit);

      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null && response.body!.posts.isNotEmpty) {
        final Result<List<Post>> validatedPosts = _validatePostData(response.body!.posts);
        if (skip == 0 && validatedPosts.isRight()) {
          _cachedPosts = validatedPosts.getOrElse((Failure _) => <Post>[]);
        }
        return validatedPosts;
      } else {
        return _getCachedPostsOrFailure(statusCode, response.error.toString(), skip);
      }
    } on Exception catch (error) {
      log(error.toString());
      return _getCachedPostsOrFailure(StatusCode.http500, error.toString(), skip);
    }
  }

  Result<List<Post>> _getCachedPostsOrFailure(StatusCode statusCode, String errorMessage, int skip) {
    if (skip == 0 && _cachedPosts != null && _cachedPosts!.isNotEmpty) {
      return right(_cachedPosts!);
    }
    return _failureHandler.handleServerError<List<Post>>(statusCode, errorMessage);
  }

  Result<List<Post>> _validatePostData(List<PostDTO> postDTOs) {
    final List<Post> posts = postDTOs.map((PostDTO postDTO) => postDTO.toDomain()).toList();
    final Post? invalid = posts.firstOrNullWhere((Post p) => p.validate.isSome());

    return invalid == null ? right(posts) : left(invalid.validate.asSome());
  }
}
