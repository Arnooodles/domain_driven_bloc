import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/app/helpers/extensions/object_ext.dart';
import 'package:very_good_core/core/domain/entity/address.dart';
import 'package:very_good_core/core/domain/entity/enum/gender.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';

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

  Option<Failure> get failureOption => uid.failureOrUnit
      .andThen(() => email.failureOrUnit)
      .andThen(() => firstName.failureOrUnit)
      .andThen(() => lastName.failureOrUnit)
      .andThen(() => username.failureOrUnit)
      .andThen(() => phone.nullableFailureOrUnit())
      .andThen(() => image.nullableFailureOrUnit())
      .andThen(
        () => address != null ? address!.failureOption.fold(() => right(unit), left<Failure, Unit>) : right(unit),
      )
      .fold(some, (_) => none());
}
