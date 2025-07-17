import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';

part 'reddit_post.dto.freezed.dart';
part 'reddit_post.dto.g.dart';

@freezed
sealed class RedditPostDTO with _$RedditPostDTO {
  const factory RedditPostDTO({required RedditPostData data, String? kind}) = _RedditPostDTO;

  factory RedditPostDTO.fromJson(Map<String, dynamic> json) => _$RedditPostDTOFromJson(json);
}

@freezed
sealed class RedditPostData with _$RedditPostData {
  const factory RedditPostData({
    required List<RedditPostDataChild> children,
    String? after,
    int? dist,
    String? modhash,
    dynamic geoFilter,
    dynamic before,
  }) = _RedditPostData;

  factory RedditPostData.fromJson(Map<String, dynamic> json) => _$RedditPostDataFromJson(json);
}

@freezed
sealed class RedditPostDataChild with _$RedditPostDataChild {
  const factory RedditPostDataChild({required PostDTO data}) = _RedditPostDataChild;

  factory RedditPostDataChild.fromJson(Map<String, dynamic> json) => _$RedditPostDataChildFromJson(json);
}
