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
  late MockIPostRepository postRepository;

  late Failure failure;
  List<Post> posts = <Post>[];

  setUp(() {
    postRepository = MockIPostRepository();
    failure =
        const Failure.serverError(StatusCode.http500, 'INTERNAL SERVER ERROR');
    posts = <Post>[
      PostDTO(
        uid: '1',
        title: 'title',
        author: 'author',
        permalink: 'permalink',
        createdUtc: DateTime.now(),
      ).toDomain(),
    ];
  });

  tearDown(() {
    reset(postRepository);
  });

  group('PostBloc getPosts', () {
    blocTest<PostBloc, PostState>(
      'should emit a success state with list of posts',
      build: () {
        provideDummy(
          Either<Failure, List<Post>>.right(posts),
        );
        when(postRepository.getPosts())
            .thenAnswer((_) async => Either<Failure, List<Post>>.right(posts));

        return PostBloc(postRepository);
      },
      act: (PostBloc bloc) => bloc.getPosts(),
      expect: () =>
          <PostState>[const PostState.loading(), PostState.success(posts)],
    );
    blocTest<PostBloc, PostState>(
      'should emit a failed state with posts from local storage ',
      build: () {
        provideDummy(
          Either<Failure, List<Post>>.left(failure),
        );
        when(postRepository.getPosts())
            .thenAnswer((_) async => Either<Failure, List<Post>>.left(failure));

        return PostBloc(postRepository);
      },
      act: (PostBloc bloc) => bloc.getPosts(),
      expect: () =>
          <PostState>[const PostState.loading(), PostState.failed(failure)],
    );

    blocTest<PostBloc, PostState>(
      'should emit a failed state with an Exception error ',
      build: () {
        when(postRepository.getPosts())
            .thenThrow(Exception('Unexpected error'));

        return PostBloc(postRepository);
      },
      act: (PostBloc bloc) => bloc.getPosts(),
      expect: () => <PostState>[
        const PostState.loading(),
        PostState.failed(
          Failure.unexpected(Exception('Unexpected error').toString()),
        ),
      ],
    );
  });
}
