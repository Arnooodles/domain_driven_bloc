part of 'post_cubit.dart';

@freezed
sealed class PostState with _$PostState {
  const factory PostState.initial() = _Initial;
  const factory PostState.loading() = _Loading;
  const factory PostState.loadingMore(List<Post> posts) = _LoadingMore;
  const factory PostState.onSuccess(List<Post> posts, {required bool hasMore}) = _Success;

  const PostState._();
}
