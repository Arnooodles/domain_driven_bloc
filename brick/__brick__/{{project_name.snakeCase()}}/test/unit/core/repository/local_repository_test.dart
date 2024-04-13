import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:{{project_name.snakeCase()}}/core/data/repository/local_storage_repository.dart';

import 'local_repository_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<SharedPreferences>(),
  MockSpec<FlutterSecureStorage>(),
])
void main() {
  late MockSharedPreferences unsecuredStorage;
  late MockFlutterSecureStorage secureStorage;
  late LocalStorageRepository localStorageRepository;

  setUp(() {
    unsecuredStorage = MockSharedPreferences();
    secureStorage = MockFlutterSecureStorage();
    localStorageRepository =
        LocalStorageRepository(secureStorage, unsecuredStorage);
  });

  tearDown(() {
    unsecuredStorage.clear();
    secureStorage.deleteAll();
    reset(unsecuredStorage);
    reset(secureStorage);
  });

  group('Secure Storage', () {
    group('access token', () {
      test(
        'should return the access token',
        () async {
          const String matcher = 'accessToken';
          when(secureStorage.read(key: 'access_token'))
              .thenAnswer((_) async => matcher);

          final String? accessToken =
              await localStorageRepository.getAccessToken();

          expect(accessToken, matcher);
        },
      );
      test(
        'should return true if the access token is saved successfully',
        () async {
          when(
            secureStorage.write(
              key: 'access_token',
              value: anyNamed('value'),
            ),
          ).thenAnswer((_) async => true);

          await localStorageRepository.setAccessToken('access_token');

          verify(localStorageRepository.setAccessToken('access_token'))
              .called(1);
        },
      );
      test(
        'should throw an exception if an unexpected error occurs when saving',
        () async {
          when(
            secureStorage.write(
              key: 'access_token',
              value: anyNamed('value'),
            ),
          ).thenThrow(throwsException);

          expect(
            () => localStorageRepository.setAccessToken('access_token'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('refresh token', () {
      test(
        'should return the refresh token',
        () async {
          const String matcher = 'refreshToken';
          when(secureStorage.read(key: 'refresh_token'))
              .thenAnswer((_) async => matcher);

          final String? refreshToken =
              await localStorageRepository.getRefreshToken();

          expect(refreshToken, matcher);
        },
      );
      test(
        'should return true if the refresh token is saved',
        () async {
          when(
            secureStorage.write(
              key: 'refresh_token',
              value: anyNamed('value'),
            ),
          ).thenAnswer((_) async => true);

          await localStorageRepository.setRefreshToken('refresh_token');

          verify(localStorageRepository.setRefreshToken('refresh_token'))
              .called(1);
        },
      );
      test(
        'should throws an exception if an unexpected error occurs when saving',
        () async {
          when(
            secureStorage.write(
              key: 'refresh_token',
              value: anyNamed('value'),
            ),
          ).thenThrow(throwsException);

          expect(
            () => localStorageRepository.setRefreshToken('refresh_token'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });

  group('Unsecure Storage', () {
    group('last logged in email', () {
      test(
        'should return the last logged in email',
        () async {
          const String matcher = 'email@example.com';
          when(unsecuredStorage.getString('email_address')).thenReturn(matcher);

          final String? lastLoggedInEmail =
              await localStorageRepository.getLastLoggedInEmail();

          expect(lastLoggedInEmail, matcher);
        },
      );
      test(
        'should return true if the refresh token is saved',
        () async {
          when(unsecuredStorage.setString('email_address', any))
              .thenAnswer((_) async => true);

          await localStorageRepository
              .setLastLoggedInEmail('email@example.com');

          verify(
            localStorageRepository.setLastLoggedInEmail('email@example.com'),
          ).called(1);
        },
      );
      test(
        'should throws an exception if an unexpected error occurs when saving',
        () async {
          when(unsecuredStorage.setString('email_address', any))
              .thenThrow(throwsException);

          expect(
            () => localStorageRepository
                .setLastLoggedInEmail('email@example.com'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
