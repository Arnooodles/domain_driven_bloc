import 'dart:developer';

import 'package:chopper/chopper.dart' as chopper;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/app/helpers/extensions/int_ext.dart';
import 'package:very_good_core/app/helpers/extensions/status_code_ext.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/data/dto/reddit_post.dto.dart';
import 'package:very_good_core/features/home/data/service/post_service.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';
import 'package:very_good_core/features/home/domain/interface/i_post_repository.dart';

// ignore_for_file: avoid_dynamic_calls
@LazySingleton(as: IPostRepository)
class PostRepository implements IPostRepository {
  const PostRepository(this._postService);

  final PostService _postService;

  FailureHandler get _failureHandler => getIt<FailureHandler>();

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final chopper.Response<RedditPostDTO> response = await _postService.getPosts();

      final StatusCode statusCode = response.statusCode.statusCode;

      return statusCode.isSuccess && response.body != null && response.body!.data.children.isNotEmpty
          ? _validatePostData(response.body!.data.children.map((RedditPostDataChild value) => value.data).toList())
          : _failureHandler.handleServerError<List<Post>>(statusCode, response.error.toString());
    } on Exception catch (error) {
      log(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  Either<Failure, List<Post>> _validatePostData(List<PostDTO> postDTOs) {
    final List<Post> posts = postDTOs.map((PostDTO postDTO) => postDTO.toDomain()).toList();
    // check if the post data does not have invalid values(if list is empty
    // then there are no invalid posts)
    final bool isPostsValid = posts.where((Post post) => post.validate.isSome()).toList().isEmpty;

    return isPostsValid
        ? right(posts)
        : left(
            posts.firstWhere((Post post) => post.validate.isSome()).validate.asSome(),
          ); // return the first invalid post
  }
}
