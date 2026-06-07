import 'package:very_good_core/core/data/dto/user.dto.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/features/home/data/dto/post.dto.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

final class MockData {
  static final Post post = const PostDTO(
    uid: 1,
    title: 'Turpis in eu mi bibendum neque egestas congue.',
    body:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    tags: <String>['flutter', 'dart', 'mobile'],
    reactions: PostReactionsDTO(likes: 192, dislikes: 5),
    views: 1024,
    userId: 1,
  ).toDomain();

  static final User user = UserDTO(
    uid: 1,
    email: 'exampe@email.com',
    firstName: 'test',
    lastName: 'test',
    gender: 'Male',
    phone: '123456789',
    birthDate: DateTime(2000).toIso8601String(),
    username: 'username',
  ).toDomain();
}
