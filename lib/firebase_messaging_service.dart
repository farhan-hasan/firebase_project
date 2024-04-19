
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    // Hide state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      print(message.notification?.title);
      print(message.notification?.body);
    });

    // Foreground
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data);
      print(message.notification?.title);
      print(message.notification?.body);
    });

    // Closed state
    FirebaseMessaging.onBackgroundMessage(doSomething);
  }

  static Future<String?> getFCMToken() async {
    return _firebaseMessaging.getToken();
  }

  static Future<void> _listenToTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      // send token to the backend
    });
  }
}

Future<void> doSomething(RemoteMessage message) async {
  // some code
}