import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/value_objects.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post_details/post_details_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MockWebViewController extends Mock implements WebViewController {
  @override
  Future<void> loadRequest(
    Uri? uri, {
    LoadRequestMethod? method = LoadRequestMethod.get,
    Map<String, String>? headers = const <String, String>{},
    Uint8List? body,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #loadRequest,
          <Object?>[uri],
          <Symbol, Object?>{
            #method: method,
            #headers: headers,
            #body: body,
          },
        ),
        returnValue: Future<void>.value(),
        returnValueForMissingStub: Future<void>.value(),
      ) as Future<void>;

  @override
  Future<bool> canGoBack() => super.noSuchMethod(
        Invocation.method(
          #canGoBack,
          <Object?>[],
        ),
        returnValue: Future<bool>.value(false),
        returnValueForMissingStub: Future<bool>.value(false),
      ) as Future<bool>;

  @override
  Future<void> goBack() => super.noSuchMethod(
        Invocation.method(
          #goBack,
          <Object?>[],
        ),
        returnValue: Future<void>.value(),
        returnValueForMissingStub: Future<void>.value(),
      ) as Future<void>;
}

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
        // arrange
        when(postDetailsBloc.state.controller.canGoBack())
            .thenAnswer((_) async => true);
        // act
        final bool canGoBack = await postDetailsBloc.webViewBack();
        // assert
        expect(canGoBack, false);
      },
    );
    test(
      'should return true',
      () async {
        // arrange
        when(postDetailsBloc.state.controller.canGoBack())
            .thenAnswer((_) async => false);
        // act
        final bool canGoBack = await postDetailsBloc.webViewBack();
        // assert
        expect(canGoBack, true);
      },
    );
  });
}
