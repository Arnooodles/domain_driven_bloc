import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/injection.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/presentation/widgets/connectivity_checker.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/features/home/domain/bloc/post_details/post_details_bloc.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostDetailsWebview extends StatelessWidget {
  const PostDetailsWebview({required this.post, super.key});

  final Post post;

  Future<void> _onPopInvoked(
    BuildContext context,
    WebViewController controller,
  ) async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider<PostDetailsBloc>(
        create: (BuildContext context) =>
            getIt<PostDetailsBloc>(param1: post.permalink),
        child:
            BlocSelector<PostDetailsBloc, PostDetailsState, WebViewController>(
          selector: (PostDetailsState state) => state.controller,
          builder: (BuildContext context, WebViewController controller) =>
              PopScope(
            canPop: false,
            onPopInvoked: (_) async => _onPopInvoked(context, controller),
            child: ConnectivityChecker.scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppTheme.defaultAppBarHeight),
                child: VeryGoodCoreAppBar(
                  titleColor: context.colorScheme.primary,
                  leading: BackButton(
                    color: context.colorScheme.primary,
                    onPressed: () => GoRouter.of(context).pop(),
                  ),
                ),
              ),
              body: Center(
                child: Stack(
                  children: <Widget>[
                    WebViewWidget(controller: controller),
                    BlocSelector<PostDetailsBloc, PostDetailsState, int>(
                      selector: (PostDetailsState state) =>
                          state.loadingProgress,
                      builder: (BuildContext context, int progress) =>
                          progress != 100
                              ? LinearProgressIndicator(value: progress / 100)
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
