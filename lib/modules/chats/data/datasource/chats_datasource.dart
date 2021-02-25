import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


abstract class ChatsDataSource {
}

class ChatsDataSourceImpl extends ChatsDataSource {
  final http.Client client;

  ChatsDataSourceImpl({@required this.client});

}
