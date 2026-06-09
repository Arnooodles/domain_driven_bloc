import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/data/dto/post_list.dto.dart';
import 'package:very_good_core/features/home/data/repository/post_repository.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

void main() {
  group(PostRepository, () {
    late MockPostService postService;
    late MockFailureHandler failureHandler;
    late PostRepository postRepository;
    late PostDTO postDTO;
    late MockTalker talker;

    setUp(() {
      postService = MockPostService();
      failureHandler = MockFailureHandler();
      talker = MockTalker();
      postRepository = PostRepository(postService, talker);
      postDTO = const PostDTO(
        uid: 1,
        title: 'title',
        body: 'body content',
        tags: <String>['flutter', 'dart'],
        reactions: PostReactionsDTO(likes: 5, dislikes: 1),
        views: 100,
      );

      // Register dummy values to prevent Mockito's MissingDummyValueError under randomized ordering.
      provideDummy<Result<List<Post>>>(left(const Failure.unexpected('dummy')));
      provideDummy(mockChopperClient);
      provideDummy<chopper.Response<PostListDTO>>(
        generateMockResponse<PostListDTO>(PostListDTO(posts: <PostDTO>[postDTO], total: 1, skip: 0, limit: 20), 200),
      );
    });

    tearDown(() {
      reset(postService);
      reset(failureHandler);
    });

    group('getPosts', () {
      test('getPosts should return list of posts when successful', () async {
        final PostListDTO data = PostListDTO(posts: <PostDTO>[postDTO], total: 1, skip: 0, limit: 20);

        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 200));

        final Result<List<Post>> result = await postRepository.getPosts().run();

        expect(result, isA<Right<Failure, List<Post>>>());
        expect(result.asRight(), isNotEmpty);
      });

      test('getPosts should return failure when list has invalid post', () async {
        // A post with negative likes is invalid
        final PostDTO invalidPostDTO = postDTO.copyWith(reactions: const PostReactionsDTO(likes: -1, dislikes: 0));
        final PostListDTO data = PostListDTO(posts: <PostDTO>[invalidPostDTO], total: 1, skip: 0, limit: 20);

        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 200));

        final Result<List<Post>> result = await postRepository.getPosts().run();

        expect(result, isA<Left<Failure, List<Post>>>());
      });

      test('getPosts should return failure when server error occurs', () async {
        final PostListDTO data = PostListDTO(posts: <PostDTO>[postDTO], total: 1, skip: 0, limit: 20);

        provideDummy<Result<List<Post>>>(left(const Failure.unexpected('Server error')));
        when(
          failureHandler.handleServerError<List<Post>>(any, any),
        ).thenReturn(left(const Failure.unexpected('Server error')));
        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 500));

        final Result<List<Post>> result = await postRepository.getPosts().run();

        expect(result, isA<Left<Failure, List<Post>>>());
      });

      test('getPosts should return failure when unexpected error occurs', () async {
        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenThrow(Exception('Unexpected error'));

        final Result<List<Post>> result = await postRepository.getPosts().run();

        expect(result, isA<Left<Failure, List<Post>>>());
      });

      test('getPosts with pagination skip param is forwarded correctly', () async {
        final PostListDTO data = PostListDTO(posts: <PostDTO>[postDTO], total: 50, skip: 20, limit: 20);

        when(
          postService.getPosts(skip: 20, limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 200));

        final Result<List<Post>> result = await postRepository.getPosts(skip: 20).run();

        expect(result, isA<Right<Failure, List<Post>>>());
        verify(postService.getPosts(skip: 20, limit: anyNamed('limit'))).called(1);
      });

      test('getPosts should return cached posts when available and forceRefresh is false', () async {
        final PostListDTO data = PostListDTO(posts: <PostDTO>[postDTO], total: 1, skip: 0, limit: 20);

        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 200));

        // First call to populate cache
        final Result<List<Post>> firstResult = await postRepository.getPosts().run();
        expect(firstResult, isA<Right<Failure, List<Post>>>());

        clearInteractions(postService);

        // Second call should return cached posts
        final Result<List<Post>> secondResult = await postRepository.getPosts().run();

        expect(secondResult, isA<Right<Failure, List<Post>>>());
        expect(secondResult.asRight(), isNotEmpty);
        verifyNever(postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')));
      });

      test('getPosts should fallback to cached posts when server error occurs and skip is 0', () async {
        final PostListDTO data = PostListDTO(posts: <PostDTO>[postDTO], total: 1, skip: 0, limit: 20);

        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 200));

        // First call to populate cache
        final Result<List<Post>> firstResult = await postRepository.getPosts().run();
        expect(firstResult, isA<Right<Failure, List<Post>>>());

        // Now simulate a server error on a forced refresh
        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 500));

        final Result<List<Post>> secondResult = await postRepository.getPosts(forceRefresh: true).run();

        // It should return the cached posts instead of a failure
        expect(secondResult, isA<Right<Failure, List<Post>>>());
        expect(secondResult.asRight(), isNotEmpty);
      });

      test('getPosts should fallback to cached posts when exception is thrown and skip is 0', () async {
        final PostListDTO data = PostListDTO(posts: <PostDTO>[postDTO], total: 1, skip: 0, limit: 20);

        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenAnswer((_) async => generateMockResponse<PostListDTO>(data, 200));

        // First call to populate cache
        final Result<List<Post>> firstResult = await postRepository.getPosts().run();
        expect(firstResult, isA<Right<Failure, List<Post>>>());

        // Now simulate an exception on a forced refresh
        when(
          postService.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')),
        ).thenThrow(Exception('Unexpected network error'));

        final Result<List<Post>> secondResult = await postRepository.getPosts(forceRefresh: true).run();

        // It should return the cached posts instead of a failure
        expect(secondResult, isA<Right<Failure, List<Post>>>());
        expect(secondResult.asRight(), isNotEmpty);
      });
    });
  });
}
