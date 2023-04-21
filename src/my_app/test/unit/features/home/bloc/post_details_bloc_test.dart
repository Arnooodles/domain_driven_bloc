import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/model/value_object.dart';
import 'package:very_good_core/features/home/domain/bloc/post_details/post_details_bloc.dart';

import '../../../../utils/mock_web_view_controller.dart';

void main() {
  late Url loadUrl;
  late PostDetailsBloc postDetailsBloc;
  setUp(() {
    loadUrl = Url('http://www.example.com');
    postDetailsBloc = PostDetailsBloc(loadUrl, MockWebViewController());
  });

  group('PostDetails loadView', () {
    blocTest<PostDetailsBloc, PostDetailsState>(
      'should emit the new url',
      build: () => postDetailsBloc,
      act: (PostDetailsBloc bloc) =>
          bloc.loadView(Url('http://www.example123.com')),
      expect: () => <dynamic>[
        postDetailsBloc.state
            .copyWith(webviewUrl: Url('http://www.example123.com')),
      ],
    );
  });
  group('PostDetails webViewBack', () {
    test(
      'should return false',
      () async {
        when(postDetailsBloc.state.controller.canGoBack())
            .thenAnswer((_) async => true);

        final bool canGoBack = await postDetailsBloc.webViewBack();

        expect(canGoBack, false);
      },
    );
    test(
      'should return true',
      () async {
        when(postDetailsBloc.state.controller.canGoBack())
            .thenAnswer((_) async => false);

        final bool canGoBack = await postDetailsBloc.webViewBack();

        expect(canGoBack, true);
      },
    );
  });
}
