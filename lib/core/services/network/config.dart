enum Config { baseUrl, baseScheme, baseAPIpath }

const bool isDev = true;

extension ConfigExtension on Config {
  String get value {
    switch (this) {
      case Config.baseUrl:
        return !isDev ? "api.aiocorp.kz" : 'aio-test-vps.kulenkov-group.kz';
      case Config.baseAPIpath:
        return 'api';
      default:
        return 'https';
    }
  }

  static String buildURLHead () {
    return Config.baseScheme.value + "://" + Config.baseUrl.value + '/';
  }
}
