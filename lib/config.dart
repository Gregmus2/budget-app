class GlobalConfig {
  static final GlobalConfig _singleton = GlobalConfig._internal();

  late String clientID;
  late String realmAppID;

  GlobalConfig._internal() {
    const String clientID = String.fromEnvironment('CLIENT_ID');
    if (clientID.isEmpty) {
      throw AssertionError('CLIENT_ID is not set');
    }
    this.clientID = clientID;

    const String realmAppID = String.fromEnvironment('REALM_APP_ID');
    if (realmAppID.isEmpty) {
      throw AssertionError('REALM_APP_ID is not set');
    }
    this.realmAppID = realmAppID;
  }

  factory GlobalConfig() {
    return _singleton;
  }
}