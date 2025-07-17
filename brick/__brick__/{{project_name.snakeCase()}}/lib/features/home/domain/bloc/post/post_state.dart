part of 'post_bloc.dart';

@freezed
sealed class PostState with _$PostState {
  const factory PostState.initial() = _Initial;
  const factory PostState.loading() = _Loading;
  const factory PostState.onSuccess(List<Post> posts) = _Success;

  const PostState._();
}
