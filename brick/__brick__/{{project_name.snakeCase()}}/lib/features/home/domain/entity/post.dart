import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/object_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';

part 'post.freezed.dart';

@freezed
sealed class Post with _$Post {
  const factory Post({
    required UniqueId uid,
    required ValueString title,
    required ValueString author,
    required Url permalink,
    required DateTime createdUtc,
    required Color linkFlairBackgroundColor,
    required ValueNumeric upvotes,
    required ValueNumeric comments,
    Url? urlOverriddenByDest,
    ValueString? selftext,
    ValueString? linkFlairText,
  }) = _Post;

  const Post._();

  Option<Failure> get validate => uid.validate
      .andThen(() => author.validate)
      .andThen(() => permalink.validate)
      .andThen(() => upvotes.validate)
      .andThen(() => comments.validate)
      .andThen(urlOverriddenByDest.optionalValidation)
      .fold(some, (_) => none());
}
