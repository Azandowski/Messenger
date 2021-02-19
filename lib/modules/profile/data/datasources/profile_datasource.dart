import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

abstract class ProfileDataSource {
  Future<User> getCurrentUser(String token);
}

class ProfileDataSourceImpl implements ProfileDataSource {
  
  @override
  Future<User> getCurrentUser(String token) async {
    return sl<NetworkingService>().getCurrentUser(
      token: token, onSuccess: (user) {
        return user;
      }, onError: (error) {
        throw error;
      });
  }
}
