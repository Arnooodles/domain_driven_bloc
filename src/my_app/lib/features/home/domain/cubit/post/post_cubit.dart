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

  Future<void> getPosts({bool forceRefresh = false}) async {
    await safeRun(
      action: () async {
        _skip = 0;
        safeEmit(const PostState.loading());

        final Result<List<Post>> possibleFailure = await _postRepository.getPosts(
          skip: _skip,
          forceRefresh: forceRefresh,
        );

        possibleFailure.fold(_failureHandler.handleFailure, (List<Post> posts) {
          _skip = posts.length;
          safeEmit(PostState.onSuccess(posts, hasMore: posts.length >= _limit));
        });
      },
      onError: (Exception error) => _failureHandler.handleFailure(Failure.unexpected(error.toString())),
    );
  }

  Future<void> loadMorePosts() async {
    final PostState currentState = state;
    if (currentState is! _Success || !currentState.hasMore) return;
    final List<Post> existingPosts = currentState.posts;

    await safeRun(
      action: () async {
        safeEmit(PostState.loadingMore(existingPosts));

        final Result<List<Post>> possibleFailure = await _postRepository.getPosts(skip: _skip);

        possibleFailure.fold(
          (Failure failure) {
            if (state is! _LoadingMore) return;
            safeEmit(PostState.onSuccess(existingPosts, hasMore: currentState.hasMore));
            _failureHandler.handleFailure(failure);
          },
          (List<Post> newPosts) {
            if (state is! _LoadingMore) return;
            _skip += newPosts.length;
            final List<Post> allPosts = <Post>[...existingPosts, ...newPosts];
            safeEmit(PostState.onSuccess(allPosts, hasMore: newPosts.length >= _limit));
          },
        );
      },
      onError: (Exception error) {
        _failureHandler.handleFailure(Failure.unexpected(error.toString()));
      },
    );
  }
}
