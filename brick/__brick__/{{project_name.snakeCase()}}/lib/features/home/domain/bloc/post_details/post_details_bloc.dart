import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'post_details_bloc.freezed.dart';
part 'post_details_state.dart';

@injectable
class PostDetailsBloc extends Cubit<PostDetailsState> {
  PostDetailsBloc(
    @factoryParam this._loadUrl,
  ) : super(PostDetailsState.initial()) {
    initialize(_loadUrl);
  }

  final Url _loadUrl;

  void initialize(Url loadUrl) => safeEmit(
        state.copyWith(
          webviewUrl: loadUrl,
          controller: state.controller
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(loadUrl.getOrCrash()))
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
