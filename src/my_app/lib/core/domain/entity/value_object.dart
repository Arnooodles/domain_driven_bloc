import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trust_but_verify/trust_but_verify.dart';
import 'package:uuid/uuid.dart';
import 'package:very_good_core/app/helpers/extensions/sync_validation_ext.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  @override
  int get hashCode => value.hashCode;

  Result<T> get value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  Result<Unit> get validate => value.fold(left, (_) => right(unit));

  T getValue() => value.fold((Failure failure) => throw Exception(failure.message), identity);

  bool get isValid => value.isRight();

  @override
  String toString() => 'Value:$value';
}

class UniqueId extends ValueObject<String> {
  factory UniqueId() => UniqueId._(right(const Uuid().v1()));
  const UniqueId._(this.value);

  factory UniqueId.fromUniqueString(String uniqueId) => UniqueId._(
    uniqueId
        .trust('uuid')
        .isNotEmpty()
        //TODO: disable this for now since we are using mock data
        //.isUuid()
        .verifyEither()
        .fold((ValidationError error) => left(Failure.validation(error, uniqueId)), right),
  );

  @override
  final Result<String> value;
}

class Url extends ValueObject<String> {
  factory Url(String input) => Url._(
    input
        .trust('Url')
        .isNotEmpty()
        .isUrlStrict()
        .verifyEither()
        .fold((ValidationError error) => left(Failure.validation(error, input)), right),
  );
  const Url._(this.value);
  @override
  final Result<String> value;
}

class EmailAddress extends ValueObject<String> {
  factory EmailAddress(String input) => EmailAddress._(
    input
        .trust('email')
        .isNotEmpty()
        .isEmail()
        .verifyEither()
        .fold((ValidationError error) => left(Failure.validation(error, input)), right),
  );
  const EmailAddress._(this.value);
  @override
  final Result<String> value;
}

class ValueString extends ValueObject<String> {
  factory ValueString(String input, {required String fieldName}) => ValueString._(
    input
        .trust(fieldName)
        .isNotNull()
        .isNotEmpty()
        .verifyEither()
        .fold((ValidationError error) => left(Failure.validation(error, input)), right),
  );
  const ValueString._(this.value);
  @override
  final Result<String> value;
}

class ValueNumeric extends ValueObject<num> {
  factory ValueNumeric(num? input, {required String fieldName, bool isInt = true}) => ValueNumeric._(
    input
        .trust(fieldName)
        .isNotNull()
        .isNonNegative()
        .bind((num value) {
          if (isInt && value is! int) {
            return left<ValidationError, num>(BindValidationError(fieldName, 'Value must be an integer'));
          }
          if (!isInt && value is! double) {
            return left<ValidationError, num>(BindValidationError(fieldName, 'Value must be a double'));
          }
          return right(value);
        })
        .verifyEither()
        .fold((ValidationError error) => left(Failure.validation(error, input.toString())), right),
  );
  const ValueNumeric._(this.value);
  @override
  final Result<num> value;
}

class Password extends ValueObject<String> {
  factory Password(String input, {bool isHashed = false}) => Password._(
    input
        .trust('password')
        .isNotEmpty()
        .minLength(6) // min password length
        .maxLength(100) // max password length
        .verifyEither()
        .fold(
          (ValidationError error) => left(Failure.validation(error, input)),
          // encrypt password
          (String input) => right(_encryptPassword(input, isHashed: isHashed)),
        ),
  );
  const Password._(this.value);
  @override
  final Result<String> value;

  static String _encryptPassword(String password, {bool isHashed = false}) =>
      isHashed ? sha256.convert(utf8.encode(password)).toString() : password;
}
