import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/domain/cubit/post/post_cubit.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

import '../../../../utils/generated_mocks.mocks.dart';

PostDTO _makePostDTO(int id) => PostDTO(
  uid: id,
  title: 'Test Post Title $id',
  body: 'Test body content',
  tags: <String>['flutter', 'test'],
  reactions: const PostReactionsDTO(likes: 10, dislikes: 1),
  views: 100,
);

void main() {
  group(PostCubit, () {
    late MockIPostRepository postRepository;
    late MockFailureHandler failureHandler;
    late Failure failure;
    late List<Post> posts;

    setUp(() {
      postRepository = MockIPostRepository();
      failureHandler = MockFailureHandler();
      failure = const Failure.server(StatusCode.http500, 'INTERNAL SERVER ERROR');
      posts = <Post>[_makePostDTO(1).toDomain(), _makePostDTO(2).toDomain()];

      // Register dummy values to prevent Mockito's MissingDummyValueError under randomized ordering.
      provideDummy(Result<List<Post>>.right(posts));
      provideDummy(TaskEither<Failure, List<Post>>.right(posts));
    });

    tearDown(() {
      reset(postRepository);
      reset(failureHandler);
    });

    group('getPosts', () {
      blocTest<PostCubit, PostState>(
        'should emit success state with list of posts when API call succeeds',
        build: () {
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenReturn(TaskEither<Failure, List<Post>>.right(posts));

          return PostCubit(postRepository, failureHandler);
        },
        act: (PostCubit cubit) => cubit.getPosts(),
        expect: () => <PostState>[const PostState.loading(), PostState.onSuccess(posts, hasMore: false)],
        verify: (_) {
          verify(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).called(1);
        },
      );

      blocTest<PostCubit, PostState>(
        'should emit success with hasMore=true when posts.length equals limit',
        build: () {
          final List<Post> fullPage = List<Post>.generate(20, (int i) => _makePostDTO(i).toDomain());
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenReturn(TaskEither<Failure, List<Post>>.right(fullPage));

          return PostCubit(postRepository, failureHandler);
        },
        act: (PostCubit cubit) => cubit.getPosts(),
        expect: () => <dynamic>[
          isA<PostState>().having(
            (PostState s) => s.maybeMap(loading: (_) => true, orElse: () => false),
            'isLoading',
            true,
          ),
          isA<PostState>().having(
            (PostState s) => s.maybeWhen(onSuccess: (_, bool hasMore) => hasMore, orElse: () => false),
            'hasMore',
            true,
          ),
        ],
      );

      blocTest<PostCubit, PostState>(
        'should emit failure state when API call fails',
        build: () {
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenReturn(TaskEither<Failure, List<Post>>.left(failure));

          return PostCubit(postRepository, failureHandler);
        },
        act: (PostCubit cubit) => cubit.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).called(1);
        },
      );

      blocTest<PostCubit, PostState>(
        'should emit failure state when unexpected error occurs',
        build: () {
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenThrow(Exception('Unexpected error'));
          when(failureHandler.handleException(any, any)).thenReturn(null);

          return PostCubit(postRepository, failureHandler);
        },
        act: (PostCubit cubit) => cubit.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).called(1);
          verify(failureHandler.handleException(any, any)).called(1);
        },
      );

      blocTest<PostCubit, PostState>(
        'should handle network timeout error',
        build: () {
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenThrow(Exception('Connection timeout'));
          when(failureHandler.handleException(any, any)).thenReturn(null);

          return PostCubit(postRepository, failureHandler);
        },
        act: (PostCubit cubit) => cubit.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).called(1);
          verify(failureHandler.handleException(any, any)).called(1);
        },
      );

      blocTest<PostCubit, PostState>(
        'should handle empty posts list',
        build: () {
          final List<Post> emptyPosts = <Post>[];
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenReturn(TaskEither<Failure, List<Post>>.right(emptyPosts));

          return PostCubit(postRepository, failureHandler);
        },
        act: (PostCubit cubit) => cubit.getPosts(),
        expect: () => <PostState>[const PostState.loading(), const PostState.onSuccess(<Post>[], hasMore: false)],
        verify: (_) {
          verify(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).called(1);
        },
      );
    });

    group('loadMorePosts', () {
      blocTest<PostCubit, PostState>(
        'should append new posts to existing list',
        build: () {
          // First page returns 20 posts (full page) → hasMore=true
          final List<Post> page1 = List<Post>.generate(20, (int i) => _makePostDTO(i).toDomain());
          final List<Post> page2 = <Post>[_makePostDTO(20).toDomain()];
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenReturn(TaskEither<Failure, List<Post>>.right(page1));
          when(
            postRepository.getPosts(skip: 20, limit: anyNamed('limit'), forceRefresh: anyNamed('forceRefresh')),
          ).thenReturn(TaskEither<Failure, List<Post>>.right(page2));

          return PostCubit(postRepository, failureHandler);
        },
        act: (PostCubit cubit) async {
          await cubit.getPosts();
          await cubit.loadMorePosts();
        },
        skip: 2,
        expect: () => <dynamic>[
          isA<PostState>().having(
            (PostState s) => s.maybeMap(loadingMore: (_) => true, orElse: () => false),
            'isLoadingMore',
            true,
          ),
          isA<PostState>().having(
            (PostState s) => s.maybeWhen(onSuccess: (List<Post> posts, _) => posts.length, orElse: () => 0),
            'totalPosts',
            21,
          ),
        ],
      );

      blocTest<PostCubit, PostState>(
        'should not load more when hasMore is false',
        build: () => PostCubit(postRepository, failureHandler),
        seed: () => PostState.onSuccess(posts, hasMore: false),
        act: (PostCubit cubit) => cubit.loadMorePosts(),
        expect: () => <PostState>[],
        verify: (_) {
          verifyNever(postRepository.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')));
        },
      );

      blocTest<PostCubit, PostState>(
        'should emit loadingMore and then restore onSuccess state when possibleFailure returns a Failure on loadMorePosts',
        build: () {
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenReturn(TaskEither<Failure, List<Post>>.left(failure));

          return PostCubit(postRepository, failureHandler);
        },
        seed: () => PostState.onSuccess(posts, hasMore: true),
        act: (PostCubit cubit) => cubit.loadMorePosts(),
        expect: () => <PostState>[PostState.loadingMore(posts), PostState.onSuccess(posts, hasMore: true)],
        verify: (_) {
          verify(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).called(1);
          verify(failureHandler.handleFailure(failure)).called(1);
        },
      );

      blocTest<PostCubit, PostState>(
        'should emit loadingMore and call failureHandler when unexpected error occurs on loadMorePosts',
        build: () {
          when(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).thenThrow(Exception('Unexpected error'));
          when(failureHandler.handleException(any, any)).thenReturn(null);

          return PostCubit(postRepository, failureHandler);
        },
        seed: () => PostState.onSuccess(posts, hasMore: true),
        act: (PostCubit cubit) => cubit.loadMorePosts(),
        expect: () => <PostState>[PostState.loadingMore(posts)],
        verify: (_) {
          verify(
            postRepository.getPosts(
              skip: anyNamed('skip'),
              limit: anyNamed('limit'),
              forceRefresh: anyNamed('forceRefresh'),
            ),
          ).called(1);
          verify(failureHandler.handleException(any, any)).called(1);
        },
      );
    });
  });
}
