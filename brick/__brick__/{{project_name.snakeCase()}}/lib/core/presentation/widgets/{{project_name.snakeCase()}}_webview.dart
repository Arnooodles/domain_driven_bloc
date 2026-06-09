import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:talker/talker.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/future_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Webview extends HookWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Webview({
    required this.url,
    required this.onProgressChanged,
    this.onWebViewCreated,
    this.onRefresh,
    this.refreshIndicatorColor,
    this.cacheEnabled = false,
    this.clearCache = true,
    this.horizontalScrollBarEnabled = false,
    this.useShouldOverrideUrlLoading = false,
    this.mediaPlaybackRequiresUserGesture = true,
    this.javaScriptCanOpenWindowsAutomatically = false,
    this.userAgent = '',
    this.shouldOverrideUrlLoading,
    this.onReceivedServerTrustAuthRequest,
    this.onPermissionRequest,
    this.allowsAirPlayForMediaPlayback,
    this.allowsLinkPreview,
    this.allowsPictureInPictureMediaPlayback,
    this.allowsInlineMediaPlayback,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{
      Factory<VerticalDragGestureRecognizer>(VerticalDragGestureRecognizer.new),
    },
    super.key,
  });

  final String url;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final ValueChanged<int> onProgressChanged;
  final VoidCallback? onRefresh;
  final Color? refreshIndicatorColor;
  final String userAgent;
  final bool cacheEnabled;
  final bool clearCache;
  final bool horizontalScrollBarEnabled;
  final bool useShouldOverrideUrlLoading;
  final bool mediaPlaybackRequiresUserGesture;
  final bool javaScriptCanOpenWindowsAutomatically;
  final bool? allowsAirPlayForMediaPlayback;
  final bool? allowsLinkPreview;
  final bool? allowsPictureInPictureMediaPlayback;
  final bool? allowsInlineMediaPlayback;
  final Future<PermissionResponse?> Function(InAppWebViewController, PermissionRequest?)? onPermissionRequest;
  final Future<ServerTrustAuthResponse?> Function(InAppWebViewController, URLAuthenticationChallenge)?
  onReceivedServerTrustAuthRequest;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  final Future<NavigationActionPolicy?> Function(InAppWebViewController, NavigationAction)? shouldOverrideUrlLoading;

  Talker get _talker => getIt<Talker>();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<PullToRefreshController?> pullToRefreshController = useState<PullToRefreshController?>(null);

    useEffect(() {
      pullToRefreshController.value = kIsWeb || onRefresh == null
          ? null
          : PullToRefreshController(
              settings: PullToRefreshSettings(color: refreshIndicatorColor),
              onRefresh: onRefresh,
            );
      return null;
    }, <Object?>[]);

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onWebViewCreated: onWebViewCreated,
      onProgressChanged: (_, int progress) async {
        if (progress == 100) {
          await _endRefreshing(pullToRefreshController.value);
        }
        onProgressChanged(progress);
      },
      pullToRefreshController: pullToRefreshController.value,
      initialSettings: InAppWebViewSettings(
        useShouldOverrideUrlLoading: useShouldOverrideUrlLoading,
        mediaPlaybackRequiresUserGesture: mediaPlaybackRequiresUserGesture,
        javaScriptCanOpenWindowsAutomatically: javaScriptCanOpenWindowsAutomatically,
        cacheEnabled: cacheEnabled,
        clearCache: clearCache,
        horizontalScrollBarEnabled: horizontalScrollBarEnabled,
        userAgent: userAgent,
        allowsInlineMediaPlayback: allowsInlineMediaPlayback,
        allowsAirPlayForMediaPlayback: allowsAirPlayForMediaPlayback,
        allowsLinkPreview: allowsLinkPreview,
        allowsPictureInPictureMediaPlayback: allowsPictureInPictureMediaPlayback,
      ),
      onPermissionRequest: onPermissionRequest,
      onReceivedServerTrustAuthRequest: onReceivedServerTrustAuthRequest,
      gestureRecognizers: gestureRecognizers,
      shouldOverrideUrlLoading: shouldOverrideUrlLoading,
      onReceivedError: (InAppWebViewController controller, WebResourceRequest request, WebResourceError error) =>
          _talker.error(error.description),
      onReceivedHttpError:
          (InAppWebViewController controller, WebResourceRequest request, WebResourceResponse response) =>
              _endRefreshing(pullToRefreshController.value, response: response),
      onLoadStop: (InAppWebViewController controller, WebUri? url) => _endRefreshing(pullToRefreshController.value),
    );
  }

  Future<void> _endRefreshing(PullToRefreshController? refreshController, {WebResourceResponse? response}) async {
    if (refreshController != null) {
      await refreshController.endRefreshing().logOnError();
    }
    if (response != null && kDebugMode) {
      _talker.error(response.toString());
    }
  }
}
