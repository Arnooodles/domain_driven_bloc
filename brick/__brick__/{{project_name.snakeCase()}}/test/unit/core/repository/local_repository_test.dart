import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/fpdart_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/data/repository/local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';

import '../../../utils/generated_mocks.mocks.dart';

void main() {
  late MockSharedPreferences unsecuredStorage;
  late MockFlutterSecureStorage secureStorage;
  late LocalStorageRepository localStorageRepository;

  setUp(() {
    unsecuredStorage = MockSharedPreferences();
    secureStorage = MockFlutterSecureStorage();
    localStorageRepository = LocalStorageRepository(secureStorage, unsecuredStorage);
  });

  tearDown(() {
    reset(unsecuredStorage);
    reset(secureStorage);
  });

  group('Secure Storage', () {
    group('access token', () {
      test('getAccessToken should return the access token', () async {
        const String expectedToken = 'accessToken';
        when(secureStorage.read(key: 'access_token')).thenAnswer((_) async => expectedToken);

        final Either<Failure, String?> result = await localStorageRepository.getAccessToken();

        expect(result, isA<Right<Failure, String?>>());
        expect(result.asRight(), expectedToken);
      });

      test('getAccessToken should return DeviceStorageError when exception occurs', () async {
        when(secureStorage.read(key: 'access_token')).thenThrow(Exception('Secure storage read error'));

        final Either<Failure, String?> result = await localStorageRepository.getAccessToken();

        expect(result, isA<Left<Failure, String?>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Secure storage read error');
      });

      test('setAccessToken should save the access token successfully', () async {
        when(secureStorage.write(key: 'access_token', value: anyNamed('value'))).thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await localStorageRepository.setAccessToken('access_token');

        expect(result, isA<Right<Failure, Unit>>());
        verify(secureStorage.write(key: 'access_token', value: 'access_token')).called(1);
      });

      test('setAccessToken should return failure when an unexpected error occurs', () async {
        when(
          secureStorage.write(key: 'access_token', value: anyNamed('value')),
        ).thenThrow(Exception('Unexpected error'));

        final Either<Failure, Unit> result = await localStorageRepository.setAccessToken('access_token');

        expect(result, isA<Left<Failure, Unit>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Unexpected error');
      });

      test('deleteAccessToken should delete the access token successfully', () async {
        when(secureStorage.delete(key: 'access_token')).thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await localStorageRepository.deleteAccessToken();

        expect(result, isA<Right<Failure, Unit>>());
        verify(secureStorage.delete(key: 'access_token')).called(1);
      });

      test('deleteAccessToken should return DeviceStorageError when exception occurs', () async {
        when(secureStorage.delete(key: 'access_token')).thenThrow(Exception('Delete token error'));

        final Either<Failure, Unit> result = await localStorageRepository.deleteAccessToken();

        expect(result, isA<Left<Failure, Unit>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Delete token error');
      });
    });

    group('refresh token', () {
      test('getRefreshToken should return the refresh token', () async {
        const String expectedToken = 'refreshToken';
        when(secureStorage.read(key: 'refresh_token')).thenAnswer((_) async => expectedToken);

        final Either<Failure, String?> result = await localStorageRepository.getRefreshToken();

        expect(result, isA<Right<Failure, String?>>());
        expect(result.asRight(), expectedToken);
      });

      test('getRefreshToken should return DeviceStorageError when exception occurs', () async {
        when(secureStorage.read(key: 'refresh_token')).thenThrow(Exception('Refresh token read error'));

        final Either<Failure, String?> result = await localStorageRepository.getRefreshToken();

        expect(result, isA<Left<Failure, String?>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Refresh token read error');
      });

      test('setRefreshToken should save the refresh token successfully', () async {
        when(secureStorage.write(key: 'refresh_token', value: anyNamed('value'))).thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await localStorageRepository.setRefreshToken('refresh_token');

        expect(result, isA<Right<Failure, Unit>>());
        verify(secureStorage.write(key: 'refresh_token', value: 'refresh_token')).called(1);
      });

      test('setRefreshToken should return failure when an unexpected error occurs', () async {
        when(
          secureStorage.write(key: 'refresh_token', value: anyNamed('value')),
        ).thenThrow(Exception('Unexpected error'));

        final Either<Failure, Unit> result = await localStorageRepository.setRefreshToken('refresh_token');

        expect(result, isA<Left<Failure, Unit>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Unexpected error');
      });

      test('deleteRefreshToken should delete the refresh token successfully', () async {
        when(secureStorage.delete(key: 'refresh_token')).thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await localStorageRepository.deleteRefreshToken();

        expect(result, isA<Right<Failure, Unit>>());
        verify(secureStorage.delete(key: 'refresh_token')).called(1);
      });

      test('deleteRefreshToken should return DeviceStorageError when exception occurs', () async {
        when(secureStorage.delete(key: 'refresh_token')).thenThrow(Exception('Delete refresh token error'));

        final Either<Failure, Unit> result = await localStorageRepository.deleteRefreshToken();

        expect(result, isA<Left<Failure, Unit>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Delete refresh token error');
      });
    });
  });

  group('Unsecure Storage', () {
    group('last logged in email', () {
      test('getLastLoggedInUsername should return the last logged in email', () async {
        const String expectedEmail = 'email@example.com';
        when(unsecuredStorage.getString('email_address')).thenReturn(expectedEmail);

        final Either<Failure, String?> result = await localStorageRepository.getLastLoggedInUsername();

        expect(result, isA<Right<Failure, String?>>());
        expect(result.asRight(), expectedEmail);
      });

      test('getLastLoggedInUsername should return DeviceStorageError when exception occurs', () async {
        when(unsecuredStorage.getString('email_address')).thenThrow(Exception('Email read error'));

        final Either<Failure, String?> result = await localStorageRepository.getLastLoggedInUsername();

        expect(result, isA<Left<Failure, String?>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Email read error');
      });

      test('setLastLoggedInUsername should save the email successfully', () async {
        when(unsecuredStorage.setString('email_address', any)).thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await localStorageRepository.setLastLoggedInUsername('email@example.com');

        expect(result, isA<Right<Failure, Unit>>());
        verify(unsecuredStorage.setString('email_address', 'email@example.com')).called(1);
      });

      test('setLastLoggedInUsername should return failure when an unexpected error occurs', () async {
        when(unsecuredStorage.setString('email_address', any)).thenThrow(Exception('Unexpected error'));

        final Either<Failure, Unit> result = await localStorageRepository.setLastLoggedInUsername('email@example.com');

        expect(result, isA<Left<Failure, Unit>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Unexpected error');
      });
    });

    group('is dark mode', () {
      test('getIsDarkMode should return true when dark mode is enabled', () async {
        when(unsecuredStorage.getBool('is_dark_mode')).thenReturn(true);

        final Either<Failure, bool?> result = await localStorageRepository.getIsDarkMode();

        expect(result, isA<Right<Failure, bool?>>());
        expect(result.asRight(), true);
      });

      test('getIsDarkMode should return DeviceStorageError when exception occurs', () async {
        when(unsecuredStorage.getBool('is_dark_mode')).thenThrow(Exception('Dark mode read error'));

        final Either<Failure, bool?> result = await localStorageRepository.getIsDarkMode();

        expect(result, isA<Left<Failure, bool?>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Dark mode read error');
      });

      test('setIsDarkMode should save the dark mode value successfully', () async {
        when(unsecuredStorage.setBool('is_dark_mode', any)).thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await localStorageRepository.setIsDarkMode(isDarkMode: true);

        expect(result, isA<Right<Failure, Unit>>());
        verify(unsecuredStorage.setBool('is_dark_mode', true)).called(1);
      });

      test('setIsDarkMode should return failure when an unexpected error occurs', () async {
        when(unsecuredStorage.setBool('is_dark_mode', any)).thenThrow(Exception('Unexpected error'));

        final Either<Failure, Unit> result = await localStorageRepository.setIsDarkMode(isDarkMode: true);

        expect(result, isA<Left<Failure, Unit>>());
        expect(result.asLeft(), isA<DeviceStorageError>());
        expect(result.asLeft().message, 'Exception: Unexpected error');
      });
    });
  });
}
