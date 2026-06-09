import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';

part 'post.freezed.dart';

@freezed
sealed class Post with _$Post {
  const factory Post({
    required UniqueId uid,
    required ValueString title,
    required ValueString body,
    required List<String> tags,
    required ValueNumeric likes,
    required ValueNumeric dislikes,
    required ValueNumeric views,
  }) = _Post;

  const Post._();

  Option<Failure> get validate => uid.validate
      .andThen(() => title.validate)
      .andThen(() => body.validate)
      .andThen(() => likes.validate)
      .andThen(() => dislikes.validate)
      .andThen(() => views.validate)
      .fold(some, (_) => none());
}
