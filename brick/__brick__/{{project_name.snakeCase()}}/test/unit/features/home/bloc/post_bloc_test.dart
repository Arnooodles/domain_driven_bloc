import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/model/post.dto.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/interface/i_post_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/model/post.dart';

import 'post_bloc_test.mocks.dart';

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<IPostRepository>(),
    MockSpec<ILocalStorageRepository>(),
  ],
)
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

  tearDown(() => posts = <Post>[]);

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
      'should emit a failed state with throwsException error ',
      build: () {
        when(postRepository.getPosts()).thenThrow(throwsException);

        return PostBloc(postRepository);
      },
      act: (PostBloc bloc) => bloc.getPosts(),
      expect: () => <PostState>[
        const PostState.loading(),
        PostState.failed(
          Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
  });
}
