import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

abstract class ProfileDataSource {
  Future<User> getCurrentUser(String token);
}

class ProfileDataSourceImpl implements ProfileDataSource {
  
  @override
  Future<User> getCurrentUser(String token) async {
    try {
      http.Response response = await sl<NetworkingService>().getCurrentUser(token: token);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw ServerFailure(message: response.body.toString());
      }
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
