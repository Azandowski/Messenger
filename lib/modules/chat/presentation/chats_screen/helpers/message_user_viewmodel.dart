import '../../../../../core/config/auth_config.dart';
import '../../../../../locator.dart';
import '../../../domain/entities/message.dart';
import 'package:easy_localization/easy_localization.dart';

class MessageUserViewModel {
  final MessageUser user;

  MessageUserViewModel(this.user);

  String get name {
    if (user?.name == null || user?.name == '') {
      return 'user'.tr();
    } else if (sl<AuthConfig>().user.name == user.name) {
      return 'you'.tr();
    } else {
      return user.name;
    }
  }

  String get username {
    if (user?.name == null || user?.name == '') {
      return 'user'.tr();
    } else {
      return user.name;
    }
  }
}