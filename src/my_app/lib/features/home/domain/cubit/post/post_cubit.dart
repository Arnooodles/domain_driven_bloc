import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';
import 'package:very_good_core/features/home/domain/interface/i_post_repository.dart';

part 'post_cubit.freezed.dart';
part 'post_state.dart';

@injectable
class PostCubit extends Cubit<PostState> {
  PostCubit(this._postRepository, this._failureHandler) : super(const PostState.initial());

  final IPostRepository _postRepository;
  final FailureHandler _failureHandler;

  static const int _limit = 20;
  int _skip = 0;

  Future<void> getPosts() async {
    try {
      _skip = 0;
      safeEmit(const PostState.loading());

      final Result<List<Post>> possibleFailure = await _postRepository.getPosts(skip: _skip);

      possibleFailure.fold(_failureHandler.handleFailure, (List<Post> posts) {
        _skip = posts.length;
        safeEmit(PostState.onSuccess(posts, hasMore: posts.length >= _limit));
      });
    } on Exception catch (error) {
      _failureHandler.handleFailure(Failure.unexpected(error.toString()));
    }
  }

  Future<void> loadMorePosts() async {
    final PostState currentState = state;
    // Only allow load more when currently in success state with more pages
    if (currentState is! _Success || !currentState.hasMore) return;

    try {
      final List<Post> existingPosts = currentState.posts;
      safeEmit(PostState.loadingMore(existingPosts));

      final Result<List<Post>> possibleFailure = await _postRepository.getPosts(skip: _skip);

      possibleFailure.fold(
        (Failure failure) {
          // Restore previous success state on error
          safeEmit(PostState.onSuccess(existingPosts, hasMore: currentState.hasMore));
          _failureHandler.handleFailure(failure);
        },
        (List<Post> newPosts) {
          _skip += newPosts.length;
          final List<Post> allPosts = <Post>[...existingPosts, ...newPosts];
          safeEmit(PostState.onSuccess(allPosts, hasMore: newPosts.length >= _limit));
        },
      );
    } on Exception catch (error) {
      _failureHandler.handleFailure(Failure.unexpected(error.toString()));
    }
  }
}
