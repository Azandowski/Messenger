import 'dart:convert';

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
          output = response['errors'].toString();
        } else {
          output = response.toString();
        }
      } else if (response is String) {
        output = responseStr;
      }
    } catch (e) {
      output = responseStr;
    }

    return output;
  }
}