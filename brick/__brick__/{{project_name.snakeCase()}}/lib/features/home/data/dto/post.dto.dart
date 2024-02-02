import 'package:dartx/dartx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/converters/timestamp_to_datetime.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/color_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/validators.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

part 'post.dto.freezed.dart';
part 'post.dto.g.dart';

@freezed
class PostDTO with _$PostDTO {
  const factory PostDTO({
    @JsonKey(name: 'id') required String uid,
    required String title,
    required String author,
    required String permalink,
    @TimestampToDateTime()
    @JsonKey(name: 'created_utc')
    required DateTime createdUtc,
    String? selftext,
    @JsonKey(name: 'link_flair_background_color')
    String? linkFlairBackgroundColor,
    @JsonKey(name: 'link_flair_text') String? linkFlairText,
    @JsonKey(name: 'ups', defaultValue: 0) int? upvotes,
    @JsonKey(name: 'num_comments', defaultValue: 0) int? comments,
    @JsonKey(name: 'url_overridden_by_dest') String? urlOverriddenByDest,
  }) = _PostDTO;

  const PostDTO._();

  factory PostDTO.fromJson(Map<String, dynamic> json) =>
      _$PostDTOFromJson(json);

  factory PostDTO.fromDomain(Post post) => PostDTO(
        uid: post.uid.getOrCrash(),
        title: post.title.getOrCrash(),
        author: post.author.getOrCrash(),
        permalink: post.permalink.getOrCrash(),
        selftext: post.selftext.getOrCrash(),
        createdUtc: post.createdUtc,
        linkFlairBackgroundColor:
            post.linkFlairBackgroundColor.toHex(hashSign: true),
        linkFlairText: post.linkFlairText.getOrCrash(),
        upvotes: post.upvotes.getOrCrash().toInt(),
        comments: post.comments.getOrCrash().toInt(),
        urlOverriddenByDest: post.urlOverriddenByDest?.getOrCrash(),
      );

  Post toDomain() => Post(
        uid: UniqueId.fromUniqueString(uid),
        title: ValueString(
          HtmlUnescape().convert(title).replaceAll('&#x200B;', '\u2028'),
        ),
        author: ValueName(author),
        permalink: Url('https://www.reddit.com$permalink'),
        createdUtc: createdUtc,
        linkFlairBackgroundColor: linkFlairBackgroundColor.isNotNullOrBlank
            ? ColorExt.fromHex(linkFlairBackgroundColor!)
            : AppColors.transparent,
        upvotes: Number(upvotes ?? 0),
        comments: Number(comments ?? 0),
        selftext: ValueString(
          selftext.isNotNullOrBlank
              ? HtmlUnescape()
                  .convert(selftext!)
                  .replaceAll('&#x200B;', '\u2028')
              : '',
        ),
        linkFlairText: ValueString(linkFlairText),
        urlOverriddenByDest: urlOverriddenByDest.isNotNullOrBlank
            ? validateLink(urlOverriddenByDest!).fold((_) => null, Url.new)
            : null,
      );
}
