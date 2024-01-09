import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post_details/post_details_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/model/post.dart';
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
              appBar: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(
                titleColor: context.colorScheme.primary,
                leading: BackButton(
                  color: context.colorScheme.primary,
                  onPressed: () => GoRouter.of(context).pop(),
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
