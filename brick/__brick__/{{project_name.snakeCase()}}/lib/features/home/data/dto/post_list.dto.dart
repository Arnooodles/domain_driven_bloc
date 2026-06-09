import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/dto/post.dto.dart';

part 'post_list.dto.freezed.dart';
part 'post_list.dto.g.dart';

@freezed
sealed class PostListDTO with _$PostListDTO {
  const factory PostListDTO({
    required List<PostDTO> posts,
    @JsonKey(defaultValue: 0) required int total,
    @JsonKey(defaultValue: 0) required int skip,
    @JsonKey(defaultValue: 0) required int limit,
  }) = _PostListDTO;

  factory PostListDTO.fromJson(Json json) => _$PostListDTOFromJson(json);
}
