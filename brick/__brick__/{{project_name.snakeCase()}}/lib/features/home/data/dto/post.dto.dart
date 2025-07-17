import 'package:dartx/dartx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/converters/timestamp_to_datetime.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/color_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/object_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

part 'post.dto.freezed.dart';
part 'post.dto.g.dart';

@freezed
sealed class PostDTO with _$PostDTO {
  const factory PostDTO({
    @JsonKey(name: 'id') required String uid,
    required String title,
    required String author,
    required String permalink,
    @TimestampToDateTime() @JsonKey(name: 'created_utc') required DateTime createdUtc,
    String? selftext,
    @JsonKey(name: 'link_flair_background_color') String? linkFlairBackgroundColor,
    @JsonKey(name: 'link_flair_text') String? linkFlairText,
    @JsonKey(name: 'ups', defaultValue: 0) int? upvotes,
    @JsonKey(name: 'num_comments', defaultValue: 0) int? comments,
    @JsonKey(name: 'url_overridden_by_dest') String? urlOverriddenByDest,
  }) = _PostDTO;

  const PostDTO._();

  factory PostDTO.fromJson(Map<String, dynamic> json) => _$PostDTOFromJson(json);

  factory PostDTO.fromDomain(Post post) => PostDTO(
    uid: post.uid.getValue(),
    title: post.title.getValue(),
    author: post.author.getValue(),
    permalink: post.permalink.getValue(),
    selftext: post.selftext?.getValue(),
    createdUtc: post.createdUtc,
    linkFlairBackgroundColor: post.linkFlairBackgroundColor.toHexString(hashSign: true),
    linkFlairText: post.linkFlairText?.getValue(),
    upvotes: post.upvotes.getValue().toInt(),
    comments: post.comments.getValue().toInt(),
    urlOverriddenByDest: post.urlOverriddenByDest?.getValue(),
  );

  Post toDomain() {
    final HtmlUnescape unescape = HtmlUnescape();
    return Post(
      uid: UniqueId.fromUniqueString(uid),
      title: ValueString(unescape.convert(title).replaceAll('&#x200B;', '\u2028'), fieldName: 'title'),
      author: ValueString(author, fieldName: 'author'),
      permalink: Url('https://www.reddit.com$permalink'),
      createdUtc: createdUtc,
      linkFlairBackgroundColor: linkFlairBackgroundColor.isNotNullOrBlank
          ? ColorExt.fromHexString(linkFlairBackgroundColor!)
          : AppColors.transparent,
      upvotes: ValueNumeric(upvotes ?? 0, fieldName: 'upvotes'),
      comments: ValueNumeric(comments ?? 0, fieldName: 'comments'),
      selftext: selftext.let(
        (String value) => ValueString(unescape.convert(value).replaceAll('&#x200B;', '\u2028'), fieldName: 'selftext'),
      ),
      linkFlairText: linkFlairText.let((String value) => ValueString(value, fieldName: 'linkFlairText')),
      urlOverriddenByDest: urlOverriddenByDest != null
          ? Uri.parse(urlOverriddenByDest!).isAbsolute
                ? Url(urlOverriddenByDest!)
                : null
          : null,
    );
  }
}
