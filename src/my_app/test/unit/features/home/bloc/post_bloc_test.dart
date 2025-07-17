import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/entity/enum/status_code.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/domain/bloc/post/post_bloc.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

import '../../../../utils/generated_mocks.mocks.dart';

void main() {
  group('PostBloc', () {
    late MockIPostRepository postRepository;
    late MockFailureHandler failureHandler;
    late Failure failure;
    late List<Post> posts;

    setUp(() {
      postRepository = MockIPostRepository();
      failureHandler = MockFailureHandler();
      failure = const Failure.server(StatusCode.http500, 'INTERNAL SERVER ERROR');
      posts = <Post>[
        PostDTO(
          uid: '1',
          title: 'Test Post Title',
          author: 'Test Author',
          permalink: 'https://example.com/post/1',
          createdUtc: DateTime.now(),
        ).toDomain(),
        PostDTO(
          uid: '2',
          title: 'Another Test Post',
          author: 'Another Author',
          permalink: 'https://example.com/post/2',
          createdUtc: DateTime.now(),
        ).toDomain(),
      ];
    });

    tearDown(() {
      reset(postRepository);
    });

    group('getPosts', () {
      blocTest<PostBloc, PostState>(
        'should emit success state with list of posts when API call succeeds',
        build: () {
          provideDummy(Either<Failure, List<Post>>.right(posts));
          when(postRepository.getPosts()).thenAnswer((_) async => Either<Failure, List<Post>>.right(posts));

          return PostBloc(postRepository, failureHandler);
        },
        act: (PostBloc bloc) => bloc.getPosts(),
        expect: () => <PostState>[const PostState.loading(), PostState.onSuccess(posts)],
        verify: (_) {
          verify(postRepository.getPosts()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'should emit failure state when API call fails',
        build: () {
          provideDummy(Either<Failure, List<Post>>.left(failure));
          when(postRepository.getPosts()).thenAnswer((_) async => Either<Failure, List<Post>>.left(failure));

          return PostBloc(postRepository, failureHandler);
        },
        act: (PostBloc bloc) => bloc.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(postRepository.getPosts()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'should emit failure state when unexpected error occurs',
        build: () {
          when(postRepository.getPosts()).thenThrow(Exception('Unexpected error'));

          return PostBloc(postRepository, failureHandler);
        },
        act: (PostBloc bloc) => bloc.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(postRepository.getPosts()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'should handle network timeout error',
        build: () {
          when(postRepository.getPosts()).thenThrow(Exception('Connection timeout'));

          return PostBloc(postRepository, failureHandler);
        },
        act: (PostBloc bloc) => bloc.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(postRepository.getPosts()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'should handle authentication failure',
        build: () {
          const Failure authFailure = Failure.authentication('Authentication required');
          provideDummy(Either<Failure, List<Post>>.left(authFailure));
          when(postRepository.getPosts()).thenAnswer((_) async => left(authFailure));

          return PostBloc(postRepository, failureHandler);
        },
        act: (PostBloc bloc) => bloc.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(postRepository.getPosts()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'should handle server error with different status codes',
        build: () {
          const Failure serverFailure = Failure.server(StatusCode.http404, 'Posts not found');
          provideDummy(Either<Failure, List<Post>>.left(serverFailure));
          when(postRepository.getPosts()).thenAnswer((_) async => left(serverFailure));

          return PostBloc(postRepository, failureHandler);
        },
        act: (PostBloc bloc) => bloc.getPosts(),
        expect: () => <PostState>[const PostState.loading()],
        verify: (_) {
          verify(postRepository.getPosts()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'should handle empty posts list',
        build: () {
          final List<Post> emptyPosts = <Post>[];
          provideDummy(Either<Failure, List<Post>>.right(emptyPosts));
          when(postRepository.getPosts()).thenAnswer((_) async => Either<Failure, List<Post>>.right(emptyPosts));

          return PostBloc(postRepository, failureHandler);
        },
        act: (PostBloc bloc) => bloc.getPosts(),
        expect: () => <PostState>[const PostState.loading(), const PostState.onSuccess(<Post>[])],
        verify: (_) {
          verify(postRepository.getPosts()).called(1);
        },
      );
    });
  });
}
