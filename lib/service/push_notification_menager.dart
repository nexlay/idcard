import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        //App is in foreground and you receive a notification
        onMessage: (Map<String, dynamic> message) async {
          print('onMessage: $message');
        },
        //Open app clicking on push notification
        onLaunch: (Map<String, dynamic> message) async {
          print('onMessage: $message');
        },
        //App is in background and
        onResume: (Map<String, dynamic> message) async {
          print('onMessage: $message');
        },
      );

      _initialized = true;
    }
  }
}
