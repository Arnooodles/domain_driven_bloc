import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/core/domain/interface/i_local_storage_repository.dart';
import 'package:very_good_core/core/domain/model/failure.dart';
import 'package:very_good_core/features/home/data/model/post.dto.dart';
import 'package:very_good_core/features/home/domain/bloc/post/post_bloc.dart';
import 'package:very_good_core/features/home/domain/interface/i_post_repository.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';

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

  group('PostBloc getPosts', () {
    blocTest<PostBloc, PostState>(
      'should emit a success state with list of posts',
      build: () {
        when(postRepository.getPosts()).thenAnswer((_) async => right(posts));

        return PostBloc(postRepository);
      },
      act: (PostBloc bloc) => bloc.getPosts(),
      expect: () => <PostState>[PostState.success(posts)],
    );
    blocTest<PostBloc, PostState>(
      'should emit a failed state with posts from local storage ',
      build: () {
        when(postRepository.getPosts()).thenAnswer((_) async => left(failure));

        return PostBloc(postRepository);
      },
      act: (PostBloc bloc) => bloc.getPosts(),
      expect: () => <PostState>[PostState.failed(failure)],
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
