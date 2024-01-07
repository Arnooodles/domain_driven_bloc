import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/model/value_object.dart';
import 'package:very_good_core/features/home/domain/bloc/post_details/post_details_bloc.dart';
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

  group('PostDetials', () {
    blocTest<PostDetailsBloc, PostDetailsState>(
      'should emit a state with the loaded Url',
      build: () => postBloc,
      act: (PostDetailsBloc bloc) => bloc.initialize(),
      expect: () => <PostDetailsState>[],
      verify: (PostDetailsBloc postBloc) {
        expect(postBloc.loadUrl, initialUrl);
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
