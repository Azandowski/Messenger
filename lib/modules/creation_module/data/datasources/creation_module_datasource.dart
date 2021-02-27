import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

abstract class CreationModuleDataSource {}

class CreationModuleDataSourceImpl extends CreationModuleDataSource {
  final http.Client client;

  CreationModuleDataSourceImpl({
    @required this.client
  });
}
