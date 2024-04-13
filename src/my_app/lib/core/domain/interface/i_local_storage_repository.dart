abstract interface class ILocalStorageRepository {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String? accessToken);

  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String? refreshToken);

  Future<String?> getLastLoggedInEmail();
  Future<void> setLastLoggedInEmail(String? emailAddress);
}
