abstract interface class IDeviceRepository {
  Future<String> getPhoneModel();

  Future<(String, String)> getPhoneOSVersion();

  String getAppVersion();

  String getBuildNumber();
}
