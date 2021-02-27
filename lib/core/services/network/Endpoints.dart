import 'config.dart';

enum Endpoints {
  // Authentication
  createCode,
  login,

  // Profile
  getCurrentUser,
  updateCurrentUser,

  // Chat Main Screen
  getCategories,
  createCategory,
  getAllUserChats,
  deleteCategory,
}

extension EndpointsExtension on Endpoints {
  String get scheme {
    return Config.baseScheme.value;
  }

  String get hostName {
    return Config.baseUrl.value;
  }

  Map<String, String> getHeaders({String token, Map defaultHeaders}) {
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
        return "${Config.baseAPIpath.value}/createCode";
      case Endpoints.login:
        return "${Config.baseAPIpath.value}/login";
      case Endpoints.getCurrentUser:
        return "${Config.baseAPIpath.value}/user/getCurrentUser";
      case Endpoints.updateCurrentUser:
        return '${Config.baseAPIpath.value}/user/updateCurrentUser';
      case Endpoints.getCategories:
        return '${Config.baseAPIpath.value}/messenger/category';
      case Endpoints.createCategory:
        return '${Config.baseAPIpath.value}/messenger/category/post';
      case Endpoints.getAllUserChats:
        return '${Config.baseAPIpath.value}/messenger/user/chat';
      case Endpoints.deleteCategory:
        return '${Config.baseAPIpath.value}/messenger/category';
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
