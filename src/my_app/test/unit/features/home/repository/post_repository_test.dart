import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/data/repository/post_repository.dart';
import 'package:very_good_core/features/home/data/service/post_service.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

import '../../../../utils/test_utils.dart';
import 'post_repository_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<PostService>()])
void main() {
  late MockPostService postService;
  late PostRepository postRepository;
  late PostDTO postDTO;

  setUp(() {
    postService = MockPostService();
    postRepository = PostRepository(postService);
    postDTO = PostDTO(
      uid: '1',
      title: 'title',
      author: 'author',
      permalink: 'permalink',
      createdUtc: DateTime.now(),
    );
  });

  tearDown(() {
    provideDummy(mockChopperClient);
    postService.client.dispose();
    reset(postService);
  });

  group('Get Posts', () {
    test(
      'should return a list of posts',
      () async {
        final Map<String, dynamic> data = <String, dynamic>{
          'data': <String, dynamic>{
            'children': <Map<String, dynamic>>[
              <String, dynamic>{
                'data': postDTO.toJson(),
              },
            ],
          },
        };
        provideDummy<chopper.Response<dynamic>>(
          generateMockResponse<Map<String, dynamic>>(data, 200),
        );
        when(postService.getPosts()).thenAnswer(
          (_) async => generateMockResponse<Map<String, dynamic>>(data, 200),
        );

        final Either<Failure, List<Post>> result =
            await postRepository.getPosts();

        expect(result.isRight(), true);
      },
    );
    test(
      'should return a failure when list has an invalid post',
      () async {
        final Map<String, dynamic> data = <String, dynamic>{
          'data': <String, dynamic>{
            'children': <Map<String, dynamic>>[
              <String, dynamic>{
                'data': postDTO.copyWith(comments: -1).toJson(),
              },
            ],
          },
        };
        provideDummy<chopper.Response<dynamic>>(
          generateMockResponse<Map<String, dynamic>>(data, 200),
        );
        when(postService.getPosts()).thenAnswer(
          (_) async => generateMockResponse<Map<String, dynamic>>(data, 200),
        );

        final Either<Failure, List<Post>> result =
            await postRepository.getPosts();

        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when a server error occurs',
      () async {
        final Map<String, dynamic> data = <String, dynamic>{
          'data': <String, dynamic>{
            'children': <Map<String, dynamic>>[
              <String, dynamic>{
                'data': postDTO.toJson(),
              },
            ],
          },
        };
        provideDummy<chopper.Response<dynamic>>(
          generateMockResponse<Map<String, dynamic>>(data, 500),
        );
        when(postService.getPosts()).thenAnswer(
          (_) async => generateMockResponse<Map<String, dynamic>>(data, 500),
        );

        final Either<Failure, List<Post>> result =
            await postRepository.getPosts();

        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an unexpected error occurs',
      () async {
        when(postService.getPosts()).thenThrow(throwsException);

        final Either<Failure, List<Post>> result =
            await postRepository.getPosts();

        expect(result.isLeft(), true);
      },
    );
  });
}
