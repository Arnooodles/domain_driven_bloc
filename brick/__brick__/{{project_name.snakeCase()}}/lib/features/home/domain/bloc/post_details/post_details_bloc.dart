import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/value_object.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'post_details_bloc.freezed.dart';
part 'post_details_state.dart';

@injectable
class PostDetailsBloc extends Cubit<PostDetailsState> {
  PostDetailsBloc(
    @factoryParam this.loadUrl,
  ) : super(PostDetailsState.initial(loadUrl)) {
    initialize();
  }

  final Url loadUrl;

  void initialize() => safeEmit(
        state.copyWith(
          controller: state.controller
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(state.webviewUrl.getOrCrash()))
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (NavigationRequest request) =>
                    NavigationDecision.navigate,
                onProgress: updateLoadingProgress,
              ),
            ),
        ),
      );

  void updateLoadingProgress(int progress) =>
      safeEmit(state.copyWith(loadingProgress: progress));

  Future<void> loadView(Url webviewUrl) async {
    await state.controller.loadRequest(Uri.parse(webviewUrl.getOrCrash()));
    safeEmit(state.copyWith(webviewUrl: webviewUrl));
  }
}
