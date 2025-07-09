abstract interface class ILocalStorageRepository {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String? accessToken);

  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String? refreshToken);

  Future<String?> getLastLoggedInUsername();
  Future<void> setLastLoggedInUsername(String? emailAddress);

  Future<bool?> getIsDarkMode();
  Future<void> setIsDarkMode({required bool isDarkMode});
}
