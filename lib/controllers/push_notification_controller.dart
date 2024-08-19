import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationController {
  static final PushNotificationController _singleton =
  PushNotificationController._internal();

  factory PushNotificationController() {
    return _singleton;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  SharedPreferences? _prefs;

  PushNotificationController._internal() {
    _requestNotificationPermissions();
    _initPrefs();
    _initFirebaseMessaging();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _initFirebaseMessaging() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('token $newToken');

      // Ensure _prefs is not null before proceeding
      if (_prefs == null) {
        await _initPrefs();
      }

      // Retrieve old token from SharedPreferences
      String? oldToken = _prefs?.getString('device_token');

      // Compare old and new tokens
      if (oldToken != newToken) {
        // If old token is different from new token, save the new token
        await _saveToken(newToken.toString());
        print('new token saved, $newToken');
      } else {
        // Tokens are the same, no need to update SharedPreferences
        print("Old and new tokens are the same. No update needed.");
      }
    });

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // In here if we opened our app we can manually handle the notification. if our app in the background firebase handle the notification and show it.
      print("Received message: ${message.notification!.title}");
      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(message);
        showNotifications(message);
      }
    });
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void initLocalNotifications(RemoteMessage message) async {
    var androidInitSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(message);
        });
  }

  void handleMessage(RemoteMessage message) {
    print('in handle message func');
    if (message.data['type'] == 'text') {
      // redirect to new screen or take different action based on payload that you receive.
    }
  }

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(androidNotificationChannel.id.toString(),
        androidNotificationChannel.name.toString(),
        channelDescription: 'Flutter Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
        sound: androidNotificationChannel.sound);

    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });
  }

  void _requestNotificationPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    }

    NotificationSettings notificationSettings =
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('user is already granted permission');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user is already granted provisional permission');
    } else {
      print('User has denid permission');
    }
  }

  Future<void> _saveToken(String token) async {
    // Ensure _prefs is initialized
    if (_prefs == null) {
      await _initPrefs();
    }
    await _prefs?.setString('device_token', token);
  }

  Future<String> getDeviceToken() async {
    return _prefs?.getString('device_token') ?? "";
  }
}