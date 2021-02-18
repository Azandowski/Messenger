import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<String> sendPhone(int number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {

  AuthenticationRemoteDataSourceImpl();

  @override
  Future<String> sendPhone(int number) {
    // TODO: implement sendPhone
    throw UnimplementedError();
  }
}
