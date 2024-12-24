class GlobalConfig {
  static final GlobalConfig _singleton = GlobalConfig._internal();

  late String clientID;
  late String apiURL;
  late bool secureTransport;

  GlobalConfig._internal() {
    const String clientID = String.fromEnvironment('CLIENT_ID');
    if (clientID.isEmpty) {
      throw AssertionError('CLIENT_ID is not set');
    }
    this.clientID = clientID;

    const String apiURL = String.fromEnvironment('API_URL');
    if (apiURL.isEmpty) {
      throw AssertionError('API_URL is not set');
    }
    this.apiURL = apiURL;

    secureTransport = const bool.fromEnvironment('SECURE_TRANSPORT');
  }

  factory GlobalConfig() {
    return _singleton;
  }
}
