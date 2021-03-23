import 'dart:convert';


enum ServerCustomErrors {
  blocUser, 
  userNotAdmin
}

extension ServerCustomErrorsExtension on ServerCustomErrors {

  String get key {
    switch (this) {
      case ServerCustomErrors.blocUser:
        return '"Block user"';
      case ServerCustomErrors.userNotAdmin: 
        return 'User not Admin Chat';
      default:
        return null;
    }
  }

  String get localization {
    switch (this) {
      case ServerCustomErrors.blocUser:
        return 'Пользователь заблокирован';
      case ServerCustomErrors.userNotAdmin:
        return 'Вы не являетесь админом';
      default:
        return '';
    }
  }
}

enum ServerErrors  {
  validationError
} 

extension ServerErrorsExtension on ServerErrors {
  String get key {
    switch (this) {
      case ServerErrors.validationError:
        return 'validation_error';
      default:
        return '';
    }
  }
}


class ErrorHandler {
  static String getErrorMessage (String responseStr) {
    String output = '';
    
    try {
      var response = json.decode(responseStr);
      
      if (response is Map) {
        if (response['message'] != null) {
          output = response['message'];
        } else if (response['type'] != null && response['type'] == ServerErrors.validationError.key) {
          output = 'Ошибка валидации';
        } else {
          output = response.toString();
        }
      } else if (response is String) {
        output = responseStr;
      }
    } catch (e) {
      output = responseStr;
    }

    var serverCustomError = ServerCustomErrors.values.firstWhere((e) => e.key == output, orElse: () => null);

    return serverCustomError?.localization ?? output;
  }
}