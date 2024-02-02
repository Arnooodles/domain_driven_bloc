part of 'post_details_bloc.dart';

@freezed
class PostDetailsState with _$PostDetailsState {
  factory PostDetailsState({
    required Url? webviewUrl,
    required int loadingProgress,
    required WebViewController controller,
  }) = _PostDetailsState;

  factory PostDetailsState.initial() => _PostDetailsState(
        webviewUrl: null,
        loadingProgress: 0,
        controller: WebViewController(),
      );
}
