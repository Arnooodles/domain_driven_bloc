import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/data/dto/user.dto.dart';
import 'package:very_good_core/core/data/repository/user_repository.dart';
import 'package:very_good_core/core/data/service/user_service.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/user.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/test_utils.dart';

void main() {
  late UserService userService;
  late UserRepository userRepository;
  late UserDTO user;

  setUp(() {
    userService = MockUserService();
    userRepository = UserRepository(userService);
    user = UserDTO.fromDomain(mockUser);
  });

  tearDown(() {
    provideDummy(mockChopperClient);
    userService.client.dispose();
    reset(userService);
  });

  group('User', () {
    test(
      'should return some valid user',
      () async {
        final Map<String, dynamic> data = <String, dynamic>{
          'data': user.toJson(),
        };
        provideDummy(generateMockResponse<dynamic>(data, 200));
        when(userService.getCurrentUser()).thenAnswer(
          (_) async => generateMockResponse<Map<String, dynamic>>(data, 200),
        );

        final Either<Failure, User> userRepo = await userRepository.user;

        expect(userRepo.isRight(), true);
      },
    );

    test(
      'should return none when an invalid user is returned',
      () async {
        final UserDTO invalidUser = user.copyWith(email: 'email');
        final Map<String, dynamic> data = <String, dynamic>{
          'data': invalidUser.toJson(),
        };
        provideDummy(generateMockResponse<dynamic>(data, 200));
        when(userService.getCurrentUser()).thenAnswer(
          (_) async => generateMockResponse<Map<String, dynamic>>(data, 200),
        );

        final Either<Failure, User> userRepo = await userRepository.user;

        expect(userRepo.isLeft(), true);
      },
    );

    test(
      'should return none when an server error is encountered',
      () async {
        final Map<String, dynamic> data = <String, dynamic>{'data': ''};
        provideDummy(generateMockResponse<dynamic>(data, 500));
        when(userService.getCurrentUser()).thenAnswer(
          (_) async => generateMockResponse<Map<String, dynamic>>(data, 500),
        );

        final Either<Failure, User> userRepo = await userRepository.user;

        expect(userRepo.isLeft(), true);
      },
    );

    test(
      'should return none when an unexpected error occurs',
      () async {
        when(userService.getCurrentUser())
            .thenThrow(Exception('Unexpected error'));

        final Either<Failure, User> userRepo = await userRepository.user;

        expect(userRepo.isLeft(), true);
      },
    );
  });
}
