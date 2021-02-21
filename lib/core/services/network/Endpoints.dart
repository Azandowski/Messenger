import 'config.dart';

enum Endpoints {
  // Authentication
  createCode,
  login,

  // Profile
  getCurrentUser,
  updateCurrentUser
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
      if (defaultHeaders == null && this != Endpoints.updateCurrentUser)  ...{'Content-Type' : 'application/json; charset=utf-8'},
      if (this == Endpoints.updateCurrentUser) ...{
        "Accept": "text/html,application/xml"
      }
    };
  }

  String get path {
    switch (this) {
      case Endpoints.createCode:
        return "${Config.baseAPIpath.value}/auth/createCode";
      case Endpoints.login:
        return "${Config.baseAPIpath.value}/auth/login";
      case Endpoints.getCurrentUser:
        return "${Config.baseAPIpath.value}/user/getCurrentUser";
      case Endpoints.updateCurrentUser:
        return '${Config.baseAPIpath.value}/user/updateCurrentUser';
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
