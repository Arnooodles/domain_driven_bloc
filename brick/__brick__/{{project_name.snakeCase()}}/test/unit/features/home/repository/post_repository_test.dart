import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/dto/post.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/repository/post_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

import '../../../../utils/generated_mocks.mocks.dart';
import '../../../../utils/test_utils.dart';

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
        when(postService.getPosts()).thenThrow(Exception('Unexpected error'));

        final Either<Failure, List<Post>> result =
            await postRepository.getPosts();

        expect(result.isLeft(), true);
      },
    );
  });
}
