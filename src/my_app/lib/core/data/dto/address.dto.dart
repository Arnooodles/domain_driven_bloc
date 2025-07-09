import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_core/app/helpers/extensions/object_ext.dart';
import 'package:very_good_core/core/domain/entity/address.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';

part 'address.dto.freezed.dart';
part 'address.dto.g.dart';

@freezed
sealed class AddressDTO with _$AddressDTO {
  const factory AddressDTO({String? address, String? state, String? stateCode, String? postalCode, String? country}) =
      _AddressDTO;

  const AddressDTO._();

  factory AddressDTO.fromJson(Map<String, dynamic> json) => _$AddressDTOFromJson(json);

  factory AddressDTO.fromDomain(Address address) => AddressDTO(
    address: address.address?.getValue(),
    state: address.state?.getValue(),
    stateCode: address.stateCode?.getValue(),
    postalCode: address.postalCode?.getValue(),
    country: address.country?.getValue(),
  );

  Address toDomain() => Address(
    address: address.let((String value) => ValueString(value, fieldName: 'address')),
    state: state.let((String value) => ValueString(value, fieldName: 'state')),
    stateCode: stateCode.let((String value) => ValueString(value, fieldName: 'stateCode')),
    postalCode: postalCode.let((String value) => ValueString(value, fieldName: 'postalCode')),
    country: country.let((String value) => ValueString(value, fieldName: 'country')),
  );
}
