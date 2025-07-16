import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/helpers/extensions/fpdart_ext.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/data/dto/reddit_post.dto.dart';
import 'package:very_good_core/features/home/data/repository/post_repository.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

void main() {
  late MockPostService postService;
  late PostRepository postRepository;
  late PostDTO postDTO;

  setUp(() {
    postService = MockPostService();
    postRepository = PostRepository(postService);
    postDTO = PostDTO(uid: '1', title: 'title', author: 'author', permalink: 'permalink', createdUtc: DateTime.now());
  });

  tearDown(() {
    provideDummy(mockChopperClient);
    reset(postService);
  });

  group('Get Posts', () {
    test('getPosts should return list of posts when successful', () async {
      final RedditPostDTO data = RedditPostDTO(
        data: RedditPostData(children: <RedditPostDataChild>[RedditPostDataChild(data: postDTO)]),
      );

      provideDummy<chopper.Response<RedditPostDTO>>(generateMockResponse<RedditPostDTO>(data, 200));
      when(postService.getPosts()).thenAnswer((_) async => generateMockResponse<RedditPostDTO>(data, 200));

      final Either<Failure, List<Post>> result = await postRepository.getPosts();

      expect(result, isA<Right<Failure, List<Post>>>());
      expect(result.asRight(), isNotEmpty);
    });

    test('getPosts should return failure when list has invalid post', () async {
      final RedditPostDTO data = RedditPostDTO(
        data: RedditPostData(
          children: <RedditPostDataChild>[RedditPostDataChild(data: postDTO.copyWith(comments: -1))],
        ),
      );

      provideDummy<chopper.Response<RedditPostDTO>>(generateMockResponse<RedditPostDTO>(data, 200));
      when(postService.getPosts()).thenAnswer((_) async => generateMockResponse<RedditPostDTO>(data, 200));

      final Either<Failure, List<Post>> result = await postRepository.getPosts();

      expect(result, isA<Left<Failure, List<Post>>>());
    });

    test('getPosts should return failure when server error occurs', () async {
      final RedditPostDTO data = RedditPostDTO(
        data: RedditPostData(children: <RedditPostDataChild>[RedditPostDataChild(data: postDTO)]),
      );

      provideDummy<chopper.Response<RedditPostDTO>>(generateMockResponse<RedditPostDTO>(data, 500));
      when(postService.getPosts()).thenAnswer((_) async => generateMockResponse<RedditPostDTO>(data, 500));

      final Either<Failure, List<Post>> result = await postRepository.getPosts();

      expect(result, isA<Left<Failure, List<Post>>>());
    });

    test('getPosts should return failure when unexpected error occurs', () async {
      when(postService.getPosts()).thenThrow(Exception('Unexpected error'));

      final Either<Failure, List<Post>> result = await postRepository.getPosts();

      expect(result, isA<Left<Failure, List<Post>>>());
    });
  });
}
