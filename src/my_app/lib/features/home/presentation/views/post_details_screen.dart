import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_webview.dart';
import 'package:very_good_core/core/presentation/widgets/wrappers/connectivity_checker.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

class PostDetailsScreen extends HookWidget {
  const PostDetailsScreen({required this.post, super.key});

  final Post post;

  Future<void> _onPopInvoked(BuildContext context, InAppWebViewController? controller, bool didPop) async {
    if (!didPop) {
      if (await controller?.canGoBack() ?? false) {
        await controller?.goBack();
      } else {
        if (!context.mounted) return;
        context.navigator.pop();
      }
    }
  }

  Future<void> _onRefresh(InAppWebViewController? webViewController) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await webViewController?.reload();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController.getUrl()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<InAppWebViewController?> webViewController = useState<InAppWebViewController?>(null);
    final ValueNotifier<int> loadingProgress = useState<int>(0);

    return Builder(
      builder: (BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) async => _onPopInvoked(context, webViewController.value, didPop),
        child: ConnectivityChecker.scaffold(
          appBar: VeryGoodCoreAppBar(leading: BackButton(onPressed: () => context.goRouter.pop())),
          body: Center(
            child: Stack(
              children: <Widget>[
                VeryGoodCoreWebview(
                  url: post.permalink.getValue(),
                  onRefresh: () => _onRefresh(webViewController.value),

                  onWebViewCreated: (InAppWebViewController controller) => webViewController.value = controller,
                  onProgressChanged: (int progress) => loadingProgress.value = progress,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: loadingProgress.value < 100
                      ? LinearProgressIndicator(value: loadingProgress.value / 100)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
