import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  const LocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'chat_channel',
    'chat_channel',
    description: 'this is chat_channel',
    importance: Importance.max,
  );

  static Future<void> initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsDarwin =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static showNotification(RemoteMessage message) async {
    AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails platformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        message.data['groupKey'].hashCode,
        message.notification?.title,
        message.notification?.body,
        platformSpecifics);
  }
}

@pragma('vm:entry-point')
Future<void> background(RemoteMessage message) async {
  // print('call backgroundMessage: ${message.data}');
  // print('noti: ${message.notification?.title}');
// if (message.notification != null)
//   LocalNotification.showNotification(message);
}

class FirebaseMessageController {
  FirebaseMessageController._();

  static FirebaseMessageController instance = FirebaseMessageController._();

  StreamSubscription<RemoteMessage?>? foregroundSubscription;
  StreamSubscription<RemoteMessage?>? openSubscription;

  void handleMessage(RemoteMessage message) {}

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(background);

    openSubscription ??=
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      print('call onMessageOpendApp');
      print('event.data : ${event.data}');
      handleMessage(event);
    });
  }

  void listenMessage() {
    setupInteractedMessage();
    foregroundSubscription ??=
        FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      LocalNotification.showNotification(event);
    });
  }

  void cancelSubscribe() {
    foregroundSubscription?.cancel();
    openSubscription?.cancel();
  }
}
