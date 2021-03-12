import 'package:vibrate/vibrate.dart';

class FeedbackEngine {
  static void showFeedback (FeedbackType type) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(type);
    }
  }
}