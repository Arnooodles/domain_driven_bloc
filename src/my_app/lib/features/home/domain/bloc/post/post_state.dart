part of 'post_bloc.dart';

@freezed
class PostState with _$PostState {
  const factory PostState.initial() = _Initial;
  const factory PostState.loading() = _Loading;
  const factory PostState.success(List<Post> posts) = _Success;
  const factory PostState.failed(Failure failure) = _Failure;

  const PostState._();
}
