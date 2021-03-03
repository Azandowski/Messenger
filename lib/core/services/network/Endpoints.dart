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
  updateCategory,
  getAllUserChats,
  deleteCategory,
  transferChats,
  categoryChats
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

  String getPath (List<String> params) {
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
        return '${Config.baseAPIpath.value}/messenger/category';
      case Endpoints.getAllUserChats:
        return '${Config.baseAPIpath.value}/messenger/user/chat';
      case Endpoints.deleteCategory:
        return '${Config.baseAPIpath.value}/messenger/category/${params[0]}';
      case Endpoints.updateCategory:
        return '${Config.baseAPIpath.value}/messenger/category/${params[0]}/';
      case Endpoints.categoryChats:
        return '${Config.baseAPIpath.value}/messenger/category/${params[0]}';
      case Endpoints.transferChats:
        return '${Config.baseAPIpath.value}/messenger/category/chat/transfer';
    }
  }

  Uri buildURL({
    Map<String, dynamic> queryParameters,
    List<String> urlParams
  }) {
    return Uri(
      scheme: this.scheme,
      host: this.hostName,
      path: this.getPath(urlParams),
      queryParameters: queryParameters ?? {});
  }
}
