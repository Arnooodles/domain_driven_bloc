import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/data/model/user.dto.dart';
import 'package:very_good_core/core/data/repository/user_repository.dart';
import 'package:very_good_core/core/data/service/user_service.dart';
import 'package:very_good_core/core/domain/model/failure.dart';
import 'package:very_good_core/core/domain/model/user.dart';

import '../../../utils/test_utils.dart';
import 'user_repository_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<UserService>()])
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
        when(userService.getCurrentUser()).thenThrow(throwsException);

        final Either<Failure, User> userRepo = await userRepository.user;

        expect(userRepo.isLeft(), true);
      },
    );
  });
}
