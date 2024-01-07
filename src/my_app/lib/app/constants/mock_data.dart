import 'package:very_good_core/core/data/model/user.dto.dart';
import 'package:very_good_core/core/domain/model/user.dart';
import 'package:very_good_core/features/home/data/model/post.dto.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';

final class MockData {
  static final Post post = PostDTO(
    uid: '1',
    title: 'Turpis in eu mi bibendum neque egestas congue.',
    author: 'Tempus egestas',
    permalink: '/r/FlutterDev/comments/123456/',
    selftext:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    createdUtc: DateTime.fromMillisecondsSinceEpoch(1672689610000),
  ).toDomain();

  static final User user = UserDTO(
    uid: 1,
    email: 'exampe@email.com',
    firstName: 'test',
    lastName: 'test',
    gender: 'Male',
    contactNumber: '123456789',
    birthday: DateTime(2000),
  ).toDomain();
}
