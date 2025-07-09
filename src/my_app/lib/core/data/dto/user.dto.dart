import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:very_good_core/app/helpers/extensions/object_ext.dart';
import 'package:very_good_core/core/data/dto/address.dto.dart';
import 'package:very_good_core/core/domain/entity/enum/gender.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/core/domain/entity/value_object.dart';

part 'user.dto.freezed.dart';
part 'user.dto.g.dart';

@freezed
sealed class UserDTO with _$UserDTO {
  const factory UserDTO({
    @JsonKey(name: 'id') required int uid,
    required String email,
    required String firstName,
    required String lastName,
    required String username,
    String? image,
    String? gender,
    String? phone,
    String? birthDate,
    AddressDTO? address,
  }) = _UserDTO;

  const UserDTO._();

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  factory UserDTO.fromDomain(User user) => UserDTO(
    uid: int.parse(user.uid.getValue()),
    email: user.email.getValue(),
    firstName: user.firstName.getValue(),
    lastName: user.lastName.getValue(),
    username: user.username.getValue(),
    image: user.image?.getValue(),
    gender: user.gender.name,
    phone: user.phone?.getValue(),
    birthDate: user.birthDate?.toIso8601String(),
    address: user.address.let(AddressDTO.fromDomain),
  );

  factory UserDTO.userDTOFromJson(String str) => UserDTO.fromJson(json.decode(str) as Map<String, dynamic>);

  static String userDTOToJson(UserDTO data) => json.encode(data.toJson());

  User toDomain() {
    final DateFormat format = DateFormat('yyyy-M-d');
    return User(
      uid: UniqueId.fromUniqueString(uid.toString()),
      firstName: ValueString(firstName, fieldName: 'firstName'),
      lastName: ValueString(lastName, fieldName: 'lastName'),
      email: EmailAddress(email),
      gender: Gender.values.firstWhere(
        (Gender element) => element.name == gender?.toLowerCase(),
        orElse: () => Gender.unknown,
      ),
      username: ValueString(username, fieldName: 'username'),
      birthDate: birthDate.let(format.parse),
      phone: phone.let((String value) => ValueString(value, fieldName: 'phone')),
      image: image.let(Url.new),
      address: address?.toDomain(),
    );
  }
}
