import 'package:messenger_mobile/core/services/network/config.dart';

enum Endpoints {
  // Authentication
  createCode,
  login,
}

extension EndpointsExtension on Endpoints {
  String get scheme {
    return Config.baseScheme.value;
  }

  String get hostName {
    return Config.baseUrl.value;
  }

  Map<String, String> getHeaders({token: String, Map defaultHeaders}) {
    return new Map<String, String>.from({
      if (defaultHeaders != null) ...defaultHeaders,
      if (token != null && token != "") ...{"Authorization": "Bearer $token"},
    });
  }

  String get path {
    switch (this) {
      case Endpoints.createCode:
        return "${Config.baseAPIpath.value}/createCode";
      case Endpoints.login:
        return "${Config.baseAPIpath.value}/login";
    }
  }

  Uri buildURL({Map<String, dynamic> queryParameters}) {
    return Uri(
        scheme: this.scheme,
        host: this.hostName,
        path: this.path,
        queryParameters: queryParameters ?? {});
  }
}
