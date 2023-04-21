import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
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
