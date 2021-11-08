import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPlugin {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Test Title', // Notification Title
      'Test Body', // Notification Body, set as null to remove the body
      platformChannelSpecifics,
      payload: 'New Payload', // Notification Payload
    );
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      icon: 'secondary_icon',
      sound: RawResourceAndroidNotificationSound('my_sound'),
      largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
      sound: 'my_sound.aiff',
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Test Title',
      'Test Body',
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  Future<void> showDailyAtTime() async {
    var time = Time(0, 0, 15);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Test Title at ${time.hour}:${time.minute}.${time.second}',
      'Test Body', //null
      time,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }
}
