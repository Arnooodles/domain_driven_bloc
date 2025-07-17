import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/object_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/address.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/gender.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';

part 'user.freezed.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required UniqueId uid,
    required EmailAddress email,
    required ValueString firstName,
    required ValueString lastName,
    required ValueString username,
    required Gender gender,
    Url? image,
    Address? address,
    DateTime? birthDate,
    ValueString? phone,
  }) = _User;

  const User._();

  String get name => '$firstName $lastName';

  int? get age => birthDate != null ? (DateTime.now().difference(birthDate!).inDays ~/ 365) : null;

  Option<Failure> get validate => uid.validate
      .andThen(() => email.validate)
      .andThen(() => firstName.validate)
      .andThen(() => lastName.validate)
      .andThen(() => username.validate)
      .andThen(phone.optionalValidation)
      .andThen(image.optionalValidation)
      .andThen(() => address != null ? address!.validate.fold(() => right(unit), left<Failure, Unit>) : right(unit))
      .fold(some, (_) => none());
}
