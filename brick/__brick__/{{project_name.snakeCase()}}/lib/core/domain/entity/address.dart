import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/object_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';

part 'address.freezed.dart';

@freezed
sealed class Address with _$Address {
  const factory Address({
    ValueString? address,
    ValueString? state,
    ValueString? stateCode,
    ValueString? postalCode,
    ValueString? country,
  }) = _Address;

  const Address._();

  Option<Failure> get validate => address
      .optionalValidation()
      .andThen(state.optionalValidation)
      .andThen(stateCode.optionalValidation)
      .andThen(postalCode.optionalValidation)
      .andThen(country.optionalValidation)
      .fold(some, (_) => none());

  String? get fullAddress {
    final StringBuffer buffer = StringBuffer();
    void addPart(String? part) {
      if (part != null && part.isNotEmpty) {
        if (buffer.isNotEmpty) buffer.write(', ');
        buffer.write(part);
      }
    }

    addPart(address?.getValue());
    addPart(state?.getValue());
    addPart(stateCode?.getValue());
    addPart(country?.getValue());
    addPart(postalCode?.getValue());
    return buffer.isNotEmpty ? buffer.toString() : null;
  }
}
