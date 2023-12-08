import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nex_movies/Screens/bottomNavScreen.dart';
import 'package:nex_movies/main.dart';

class NotificationServices {
  final message = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
//local notifiaction package
  void initlocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidinitlization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosinitlization = const DarwinInitializationSettings();
    var initlizationSetting = InitializationSettings(
      android: androidinitlization,
      iOS: iosinitlization,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initlizationSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleNotification(context, message);
      },
    );
  }

//init firebase messing
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      await showNotification(message);
      initlocalNotification(context, message);
    });
  }

//display notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max,
      description: 'your channel description',
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(
      Duration.zero,
      () {
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      },
    );
  }

// req. notification permission work on android v13 and above
  void requestNotification() async {
    NotificationSettings settings = await message.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notificaton authorized');
    }
    if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Notificaton provisional');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Notificaton denied');
    }
  }

// get device token
  Future<String> getDeviceToken() async {
    String? deviceToken = await message.getToken();
    return deviceToken!;
  }

// on tap on notification
  void handleNotification(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.of(context).pushReplacementNamed(BottomNavScreen.routeName);
    }
  }

//handle when in background or killed
  Future<void> backgroundmessage(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handleNotification(navigatorkey.currentContext!, message);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNotification(context, message);
    });
  }
}
