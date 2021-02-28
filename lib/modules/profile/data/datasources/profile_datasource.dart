import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class ProfileDataSource {
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final http.Client client;

  ProfileDataSourceImpl({
    @required this.client
  });
}
