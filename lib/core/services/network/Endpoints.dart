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
  categoryChats,
  reorderCategories,

  //contacts
  sendContacts,
  fetchContacts,
  chatMembers,
  changeChatSettings,

  //Group chat
  createGroupChat,
  getChatDetails,
  sendMessages,

  addMembersToChat,
  leaveChat,
  getChatMessages
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
      if (defaultHeaders == null && this != Endpoints.updateCurrentUser) ...{
        'Content-Type': 'application/json; charset=utf-8'
      },
      if (this == Endpoints.updateCurrentUser) ...{
        "Accept": "text/html,application/xml"
      }
    };
  }

  String getPath(List<String> params) {
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
      case Endpoints.reorderCategories:
        return '${Config.baseAPIpath.value}/messenger/category/actions/reorder';
      case Endpoints.sendContacts:
        return '${Config.baseAPIpath.value}/messenger/user/bind-contact';
      case Endpoints.fetchContacts:
        return '${Config.baseAPIpath.value}/messenger/user/get-contacts';
      case Endpoints.createGroupChat:
        return '${Config.baseAPIpath.value}/messenger/chat';
      case Endpoints.getChatDetails:
        return '${Config.baseAPIpath.value}/messenger/chat/${params[0]}';
      case Endpoints.chatMembers:
        return '${Config.baseAPIpath.value}/messenger/chat/${params[0]}/full-members';
      case Endpoints.sendMessages:
        return '${Config.baseAPIpath.value}/messenger/chat/${params[0]}/send-message';
      case Endpoints.addMembersToChat:
        return '${Config.baseAPIpath.value}/messenger/chat/${params[0]}/add-contacts';
      case Endpoints.leaveChat:
        return '${Config.baseAPIpath.value}/messenger/chat/leave/${params[0]}';
      case Endpoints.changeChatSettings:
        return '${Config.baseAPIpath.value}/messenger/chat/settings/${params[0]}';
      case Endpoints.getChatMessages:
        return '${Config.baseAPIpath.value}/messenger/chat/${params[0]}/get-message';
    }
  }

  Uri buildURL({Map<String, dynamic> queryParameters, List<String> urlParams}) {
    return Uri(
        scheme: this.scheme,
        host: this.hostName,
        path: this.getPath(urlParams),
        queryParameters: queryParameters ?? {});
  }
}
