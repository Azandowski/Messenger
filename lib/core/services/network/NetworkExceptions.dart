import 'dart:convert';

class AppException implements Exception {
  var message;
  final prefix;
  
  AppException([this.message, this.prefix]);
  
  String toString() {
    return "$prefix$message";
  }
}

class CustomError extends AppException {
  CustomError(String new_message) {

    try {
      var decodedMap = json.decode(new_message.toString());
      if (decodedMap["message"] != null) {
        message = decodedMap["message"];
      } else {
        message = "Undefined error";
      }
    } catch (e) {
      message = new_message.toString();
    }
  }
}
