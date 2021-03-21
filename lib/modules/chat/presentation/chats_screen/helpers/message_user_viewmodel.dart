import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

import '../../../../../locator.dart';

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