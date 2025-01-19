import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/core/domain/entity/enum/gender.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';

part 'user.freezed.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required UniqueId uid,
    required ValueName firstName,
    required ValueName lastName,
    required EmailAddress email,
    required Gender gender,
    required DateTime birthday,
    required ContactNumber contactNumber,
    required Url? avatar,
  }) = _User;

  const User._();

  String get name => '${firstName.getOrCrash()} ${lastName.getOrCrash()}';

  String get age =>
      (DateTime.now().difference(birthday).inDays ~/ 365).toString();

  Option<Failure> get failureOption => uid.failureOrUnit
      .andThen(() => firstName.failureOrUnit)
      .andThen(() => lastName.failureOrUnit)
      .andThen(() => email.failureOrUnit)
      .andThen(() => email.failureOrUnit)
      .andThen(() => contactNumber.failureOrUnit)
      .fold(some, (_) => none());
}
