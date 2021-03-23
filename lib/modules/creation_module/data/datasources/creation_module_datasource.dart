import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../../core/utils/pagination.dart';
import '../../../../locator.dart';
import '../../domain/entities/contact.dart';
import '../models/contact_model.dart';

abstract class CreationModuleDataSource {
  Future<PaginatedResult<ContactEntity>> fetchContacts(Pagination pagination);
  Future<PaginatedResult<ContactEntity>> searchContacts(
      String phoneNumber, Uri nextPageURL);
}

class CreationModuleDataSourceImpl implements CreationModuleDataSource {
  final http.Client client;
  final AuthConfig authConfig;

  CreationModuleDataSourceImpl(
      {@required this.client, @required this.authConfig});

  @override
  Future<PaginatedResult<ContactEntity>> fetchContacts(
      Pagination pagination) async {
    http.Response response = await client.get(
      Endpoints.fetchContacts.buildURL(queryParameters: {
        'limit': pagination.limit.toString(),
        'page': pagination.page.toString(),
      }),
      headers: Endpoints.getCurrentUser.getHeaders(token: authConfig.token),
    );

    if (response.isSuccess) {
      var jsonMap = json.decode(response.body)['contacts'];
      return PaginatedResult<ContactEntity>.fromJson(
        jsonMap,
        (data) => ContactModel.fromJson(data),
      );
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  Future<PaginatedResult<ContactEntity>> searchContacts(
      String phoneNumber, Uri nextPageURL) async {
    http.Response response = await client.get(
        nextPageURL ??
            Endpoints.searchContacts
                .buildURL(queryParameters: {'search': phoneNumber}),
        headers:
            Endpoints.searchContacts.getHeaders(token: sl<AuthConfig>().token));

    if (response.isSuccess) {
      var jsonMap = json.decode(response.body);
      return PaginatedResult<ContactEntity>.fromJson(
          jsonMap, (data) => ContactModel.fromJson(data));
    } else {
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }
}
