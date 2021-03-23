import '../../../../../core/config/auth_config.dart';
import '../../../../../locator.dart';
import '../../../domain/entities/message.dart';

class MessageUserViewModel {
  final MessageUser user;

  MessageUserViewModel(this.user);

  String get name {
    if (user?.name == null || user?.name == '') {
      return 'Пользователь';
    } else if (sl<AuthConfig>().user.name == user.name) {
      return 'Вы';
    } else {
      return user.name;
    }
  }
}