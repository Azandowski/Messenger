import 'package:achievement_view/achievement_view.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';

class AchievementService {
  static final AchievementService _shared = AchievementService._internal();

  factory AchievementService() {
    return _shared;
  }

  AchievementService._internal();

  showAchievmentView({
    String mainText,
    String subTitle,
    Icon icon,
    bool isError,
    @required BuildContext context
  }){
   var iconSign;
   if(icon != null){
     iconSign = iconSign; 
   }else{
     iconSign = (isError ?? true) ? Icon(Icons.error, color: AppColors.redDeleteColor) : Icon(Icons.done, color: Colors.white,);
   }
   AchievementView(
    context,
    title: mainText ?? 'success'.tr(),
    subTitle: subTitle ?? '',
    isCircle: true,
    icon: iconSign,
    alignment: Alignment.topCenter,
    borderRadius: 12.0,
    color: isError ? Colors.black : Colors.green.shade400,
    duration: Duration(milliseconds: 500),
    ).show();
  }
}