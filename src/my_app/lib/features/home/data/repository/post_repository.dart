import 'package:chopper/chopper.dart' as chopper;
import 'package:dartx/dartx.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/app/helpers/extensions/int_ext.dart';
import 'package:very_good_core/app/helpers/extensions/status_code_ext.dart';
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
  PostRepository(this._postService, this._talker);

  final PostService _postService;
  final Talker _talker;

  List<Post>? _cachedPosts;

  @override
  TaskResult<List<Post>> getPosts({int skip = 0, int limit = Constant.defaultPaginationLimit, bool forceRefresh = false}) =>
      TaskResult<List<Post>>.tryCatch(
        () async {
          if (!forceRefresh && skip == 0 && _cachedPosts != null && _cachedPosts!.isNotEmpty) {
            return _cachedPosts!;
          }

          final chopper.Response<PostListDTO> response = await _postService.getPosts(skip: skip, limit: limit);

          final StatusCode statusCode = response.statusCode.statusCode;

          if (statusCode.isSuccess && response.body != null && response.body!.posts.isNotEmpty) {
            final Result<List<Post>> validatedPosts = _validatePostData(response.body!.posts);
            if (skip == 0 && validatedPosts.isRight()) {
              _cachedPosts = validatedPosts.getOrElse((Failure _) => <Post>[]);
            }
            return validatedPosts.getOrElse((Failure failure) => throw failure);
          } else {
            return _getCachedPostsOrFailure(
              statusCode,
              response.error.toString(),
              skip,
            ).getOrElse((Failure failure) => throw failure);
          }
        },
        (Object error, StackTrace stackTrace) {
          _talker.handle(error, stackTrace);
          if (error is Failure) return error;
          return Failure.unexpected(error.toString());
        },
      );

  Result<List<Post>> _getCachedPostsOrFailure(StatusCode statusCode, String errorMessage, int skip) {
    if (skip == 0 && _cachedPosts != null && _cachedPosts!.isNotEmpty) {
      return right(_cachedPosts!);
    }
    return left(Failure.server(statusCode, errorMessage));
  }

  Result<List<Post>> _validatePostData(List<PostDTO> postDTOs) {
    final List<Post> posts = postDTOs.map((PostDTO postDTO) => postDTO.toDomain()).toList();
    final Post? invalid = posts.firstOrNullWhere((Post p) => p.validate.isSome());

    return invalid == null ? right(posts) : left(invalid.validate.asSome());
  }
}
