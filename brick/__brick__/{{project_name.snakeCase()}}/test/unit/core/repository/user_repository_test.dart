import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/fpdart_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/data/dto/user.dto.dart';
import 'package:{{project_name.snakeCase()}}/core/data/repository/user_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/test_utils.dart';

void main() {
  group('UserRepository', () {
    late MockUserService userService;
    late UserRepository userRepository;
    late UserDTO user;

    setUp(() {
      userService = MockUserService();
      userRepository = UserRepository(userService);
      user = UserDTO.fromDomain(mockUser);
    });

    tearDown(() {
      reset(userService);
    });

    group('user getter', () {
      test('should return valid user when successful', () async {
        // Given: A successful API response with valid user data
        provideDummy(generateMockResponse<UserDTO>(user, 200));
        when(userService.getCurrentUser()).thenAnswer((_) async => generateMockResponse<UserDTO>(user, 200));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return a successful result with the user
        expect(result, isA<Right<Failure, User>>());
        expect(result.asRight(), mockUser);
        verify(userService.getCurrentUser()).called(1);
      });

      test('should return failure when an invalid user is returned', () async {
        // Given: An API response with invalid user data
        final UserDTO invalidUser = user.copyWith(email: 'invalid-email');
        provideDummy(generateMockResponse<UserDTO>(invalidUser, 200));
        when(userService.getCurrentUser()).thenAnswer((_) async => generateMockResponse<UserDTO>(invalidUser, 200));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return a failure due to validation error
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<ValidationFailure>());
        verify(userService.getCurrentUser()).called(1);
      });

      test('should return server failure when API returns 500 error', () async {
        // Given: A server error response
        provideDummy(generateMockResponse<UserDTO>(user, 500));
        when(userService.getCurrentUser()).thenAnswer((_) async => generateMockResponse<UserDTO>(user, 500));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return a server failure
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<ServerError>());
        verify(userService.getCurrentUser()).called(1);
      });

      test('should return server failure when API returns 401 error', () async {
        // Given: An unauthorized error response
        provideDummy(generateMockResponse<UserDTO>(user, 401));
        when(userService.getCurrentUser()).thenAnswer((_) async => generateMockResponse<UserDTO>(user, 401));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return a server failure
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<ServerError>());
        verify(userService.getCurrentUser()).called(1);
      });

      test('should return server failure when API returns 404 error', () async {
        // Given: A not found error response
        provideDummy(generateMockResponse<UserDTO>(user, 404));
        when(userService.getCurrentUser()).thenAnswer((_) async => generateMockResponse<UserDTO>(user, 404));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return a server failure
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<ServerError>());
        verify(userService.getCurrentUser()).called(1);
      });

      test('should return unexpected failure when an exception occurs', () async {
        // Given: An unexpected exception during API call
        when(userService.getCurrentUser()).thenThrow(Exception('Unexpected error'));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return an unexpected failure
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<UnexpectedError>());
        verify(userService.getCurrentUser()).called(1);
      });

      test('should return unexpected failure when network timeout occurs', () async {
        // Given: A network timeout exception
        when(userService.getCurrentUser()).thenThrow(Exception('Connection timeout'));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return an unexpected failure
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<UnexpectedError>());
        verify(userService.getCurrentUser()).called(1);
      });
    });

    group('data validation', () {
      test('should validate user email format', () async {
        // Given: A user with invalid email format
        final UserDTO invalidEmailUser = user.copyWith(email: 'not-an-email');
        provideDummy(generateMockResponse<UserDTO>(invalidEmailUser, 200));
        when(
          userService.getCurrentUser(),
        ).thenAnswer((_) async => generateMockResponse<UserDTO>(invalidEmailUser, 200));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return validation failure
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<ValidationFailure>());
      });

      test('should validate user required fields', () async {
        // Given: A user with missing required fields
        final UserDTO incompleteUser = user.copyWith(firstName: '');
        provideDummy(generateMockResponse<UserDTO>(incompleteUser, 200));
        when(userService.getCurrentUser()).thenAnswer((_) async => generateMockResponse<UserDTO>(incompleteUser, 200));

        // When: Getting the current user
        final Either<Failure, User> result = await userRepository.user;

        // Then: Should return validation failure
        expect(result, isA<Left<Failure, User>>());
        expect(result.asLeft(), isA<ValidationFailure>());
      });
    });
  });
}
