import 'package:freezed_annotation/freezed_annotation.dart';

final class StringToDateTime implements JsonConverter<DateTime, String> {
  const StringToDateTime();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime json) => json.toIso8601String();
}
