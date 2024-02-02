import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post_details/post_details_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/mock_web_view_platform.dart';

void main() {
  late PostDetailsBloc postBloc;
  final Url initialUrl = Url('https://www.google.com');
  final Url updatedUrl = Url('https://www.bing.com');

  setUp(() {
    WebViewPlatform.instance = MockWebViewPlatform();
    postBloc = PostDetailsBloc(initialUrl);
  });

  tearDown(() => postBloc.close());

  group('PostDetials', () {
    blocTest<PostDetailsBloc, PostDetailsState>(
      'should emit a state with the loaded Url',
      build: () => postBloc,
      act: (PostDetailsBloc bloc) => bloc.initialize(initialUrl),
      expect: () => <PostDetailsState>[],
      verify: (PostDetailsBloc postBloc) {
        expect(postBloc.state.webviewUrl, initialUrl);
      },
    );

    blocTest<PostDetailsBloc, PostDetailsState>(
      'should emit a state with the updated Url',
      build: () => postBloc,
      act: (PostDetailsBloc bloc) => bloc.loadView(updatedUrl),
      expect: () => <PostDetailsState>[
        postBloc.state.copyWith(webviewUrl: updatedUrl),
      ],
    );

    blocTest<PostDetailsBloc, PostDetailsState>(
      'should emit a state with the updated progress',
      build: () => postBloc,
      act: (PostDetailsBloc bloc) => bloc.updateLoadingProgress(50),
      expect: () => <PostDetailsState>[
        postBloc.state.copyWith(loadingProgress: 50),
      ],
    );
  });
}
