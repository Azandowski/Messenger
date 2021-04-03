import 'package:easy_localization/easy_localization.dart';

enum CreationActions {
  createGroup, 
  startVideo,
  startLive,
  inviteFriends
}

extension CreationActionsUIExtension on CreationActions {
  String get title {
    switch (this) {
      case CreationActions.createGroup:
        return 'create_group'.tr();
      case CreationActions.startVideo:
        return 'start_video_meeting'.tr();
      case CreationActions.startLive:
        return 'start_live'.tr();
      case CreationActions.inviteFriends:
        return 'invite_friends'.tr();
      default:
        return '';
    }
  }

  String get iconAssetPath {
    switch (this) {
      case CreationActions.createGroup:
        return 'assets/icons/groups.png';
      case CreationActions.startVideo:
        return 'assets/icons/video.png';
      case CreationActions.startLive:
        return 'assets/icons/live.png';
      case CreationActions.inviteFriends:
        return 'assets/icons/create.png';
      default:
        return '';
    }
  }
}