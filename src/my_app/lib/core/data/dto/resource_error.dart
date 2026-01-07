import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';

part 'resource_error.g.dart';

@JsonSerializable()
class ResourceError {
  ResourceError({this.type, this.message});
  final String? type;
  final String? message;

  static const ResourceError Function(Json json) fromJsonFactory = _$ResourceErrorFromJson;

  Json toJson() => _$ResourceErrorToJson(this);
}
