import 'config.dart';

enum Endpoints {
  // Authentication
  createCode,
  login,

  // Profile
  getCurrentUser
}

extension EndpointsExtension on Endpoints {
  String get scheme {
    return Config.baseScheme.value;
  }

  String get hostName {
    return Config.baseUrl.value;
  }

  Map<String, String> getHeaders({token: String, Map defaultHeaders}) {
    return {
      if (defaultHeaders != null) ...defaultHeaders, 
      if (token != null && token != "") ...{"Authorization": "Bearer $token"},
      if (defaultHeaders == null) ...{'Content-Type' : 'application/json; charset=utf-8'}
    };
  }

  String get path {
    switch (this) {
      case Endpoints.createCode:
        return "${Config.baseAPIpath.value}/user/createCode";
      case Endpoints.login:
        return "${Config.baseAPIpath.value}/user/login";
      case Endpoints.getCurrentUser:
        return "${Config.baseAPIpath.value}/user/getCurrentUser";
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
