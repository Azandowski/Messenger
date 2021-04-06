import 'dart:io';

import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationHandler {

  final String _appID = '7b554f28-7075-49ef-91a9-dc65ad834861';

  Future<void> initNotifications () async {
    OneSignal.shared.init(
      _appID,
      iOSSettings: {
        OSiOSSettings.autoPrompt: true,
        OSiOSSettings.inAppLaunchUrl: false
      }
    );

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    
    if (Platform.isIOS) {
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    }
    
    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("[OneSignal.shared.setSubscriptionObserver]");
      print(changes);
    });

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
      print(notification);
    });
  }
}