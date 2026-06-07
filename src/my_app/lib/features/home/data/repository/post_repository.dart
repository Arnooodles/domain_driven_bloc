import 'dart:developer';

import 'package:chopper/chopper.dart' as chopper;
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
  const PostRepository(this._postService, this._failureHandler);

  final PostService _postService;
  final FailureHandler _failureHandler;

  @override
  Future<Result<List<Post>>> getPosts({int skip = 0, int limit = 20}) async {
    try {
      final chopper.Response<PostListDTO> response = await _postService.getPosts(skip: skip, limit: limit);

      final StatusCode statusCode = response.statusCode.statusCode;

      return statusCode.isSuccess && response.body != null && response.body!.posts.isNotEmpty
          ? _validatePostData(response.body!.posts)
          : _failureHandler.handleServerError<List<Post>>(statusCode, response.error.toString());
    } on Exception catch (error) {
      log(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  Result<List<Post>> _validatePostData(List<PostDTO> postDTOs) {
    final List<Post> posts = postDTOs.map((PostDTO postDTO) => postDTO.toDomain()).toList();
    final Post? invalid = posts.cast<Post?>().firstWhere((Post? p) => p!.validate.isSome(), orElse: () => null);

    return invalid == null ? right(posts) : left(invalid.validate.asSome());
  }
}
