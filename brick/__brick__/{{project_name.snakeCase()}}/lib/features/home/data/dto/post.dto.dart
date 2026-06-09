import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

part 'post.dto.freezed.dart';
part 'post.dto.g.dart';

@freezed
sealed class PostDTO with _$PostDTO {
  const factory PostDTO({
    @JsonKey(name: 'userId') required int uid,
    required String title,
    @JsonKey(name: 'body') required String body,
    @JsonKey(defaultValue: <String>[]) required List<String> tags,
    @JsonKey(name: 'reactions') required PostReactionsDTO reactions,
    @JsonKey(defaultValue: 0) required int views,
  }) = _PostDTO;

  const PostDTO._();

  factory PostDTO.fromJson(Json json) => _$PostDTOFromJson(json);

  factory PostDTO.fromDomain(Post post) => PostDTO(
    uid: int.parse(post.uid.getValue()),
    title: post.title.getValue(),
    body: post.body.getValue(),
    tags: post.tags,
    reactions: PostReactionsDTO(likes: post.likes.getValue().toInt(), dislikes: post.dislikes.getValue().toInt()),
    views: post.views.getValue().toInt(),
  );

  Post toDomain() => Post(
    uid: UniqueId.fromUniqueString(uid.toString()),
    title: ValueString(title, fieldName: 'title'),
    body: ValueString(body, fieldName: 'body'),
    tags: tags,
    likes: ValueNumeric(reactions.likes, fieldName: 'likes'),
    dislikes: ValueNumeric(reactions.dislikes, fieldName: 'dislikes'),
    views: ValueNumeric(views, fieldName: 'views'),
  );
}

@freezed
sealed class PostReactionsDTO with _$PostReactionsDTO {
  const factory PostReactionsDTO({
    @JsonKey(defaultValue: 0) required int likes,
    @JsonKey(defaultValue: 0) required int dislikes,
  }) = _PostReactionsDTO;

  factory PostReactionsDTO.fromJson(Json json) => _$PostReactionsDTOFromJson(json);
}
