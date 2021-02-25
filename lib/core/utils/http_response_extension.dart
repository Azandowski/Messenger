import 'package:http/http.dart' as http;

extension HttpResponseExtension on http.Response {
  bool get isSuccess {
    return this.statusCode >= 200 && this.statusCode <= 299;
  }
}