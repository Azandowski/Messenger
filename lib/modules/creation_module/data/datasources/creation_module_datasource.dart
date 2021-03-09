import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/utils/pagination.dart';
import '../../../../locator.dart';
import 'package:messenger_mobile/core/utils/http_response_extension.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/utils/error_handler.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';

abstract class CreationModuleDataSource {
  Future<PaginatedResult<ContactEntity>> fetchContacts(Pagination pagination);
}

class CreationModuleDataSourceImpl implements CreationModuleDataSource {
  final http.Client client;

  CreationModuleDataSourceImpl({
    @required this.client
  });

  @override
  Future<PaginatedResult<ContactEntity>> fetchContacts(
    Pagination pagination
  ) async {
    
    http.Response response = await client.get(
      Endpoints.fetchContacts.buildURL(queryParameters: {
        'limit': pagination.limit.toString(),
        'page': pagination.page.toString(),
      }),
      headers: Endpoints.getCurrentUser.getHeaders(token: sl<AuthConfig>().token),
    );

    if (response.isSuccess) {
      var jsonMap = json.decode(response.body)['contacts'];
      return  PaginatedResult<ContactEntity>.fromJson(
        jsonMap, 
        (data) => ContactModel.fromJson(data));
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }
}
