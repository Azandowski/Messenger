enum Config { baseUrl, baseScheme, baseAPIpath }

const bool isDev = false;

extension ConfigExtension on Config {
  String get value {
    switch (this) {
      case Config.baseUrl:
        return !isDev ? "api.aiocorp.kz" : 'aio-test.kulenkov-group.kz';
      case Config.baseAPIpath:
        return 'api';
      default:
        return 'https';
    }
  }
}

