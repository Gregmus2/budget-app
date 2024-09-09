class GlobalConfig {
  static final GlobalConfig _singleton = GlobalConfig._internal();

  late String clientID;

  GlobalConfig._internal() {
    const String clientID = String.fromEnvironment('CLIENT_ID');
    if (clientID.isEmpty) {
      throw AssertionError('CLIENT_ID is not set');
    }
    this.clientID = clientID;
  }

  factory GlobalConfig() {
    return _singleton;
  }
}
