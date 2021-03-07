import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/utils/pagination.dart';
import '../../../../locator.dart';
import '../models/contact_response.dart';

abstract class CreationModuleDataSource {
  Future<ContactResponse> fetchContacts(Pagination pagination);
}

class CreationModuleDataSourceImpl implements CreationModuleDataSource {
  final http.Client client;

  CreationModuleDataSourceImpl({
    @required this.client
  });

  @override
  Future<ContactResponse> fetchContacts(Pagination pagination) async {
    http.Response response = await client.get(
      Endpoints.fetchContacts.buildURL(queryParameters: {
        'limit': pagination.limit.toString(),
        'page': pagination.page.toString(),
      }),
      headers: Endpoints.getCurrentUser.getHeaders(token: sl<AuthConfig>().token),
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return ContactResponse.fromJson(jsonMap);
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }
}
