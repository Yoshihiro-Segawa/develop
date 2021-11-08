import 'package:bacchusflutter/ui/edit_drink.dart';
import 'package:bacchusflutter/ui/edit_preset.dart';
import 'package:bacchusflutter/ui/list_screen.dart';
import 'package:bacchusflutter/ui/login.dart';
import 'package:bacchusflutter/ui/main_screen.dart';
import 'package:bacchusflutter/ui/personal_screen.dart';
import 'package:bacchusflutter/ui/preset_screen.dart';
import 'package:bacchusflutter/ui/webview.dart';
import 'package:bacchusflutter/ui/webview2.dart';
import 'package:bacchusflutter/utils/shared_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  void selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(buiilder:(context) => SecondScreen(payload));
    // );
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingAndroid =
      AndroidInitializationSettings('bacchus_shiro512');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: (id, title, body, payload) async {});
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

  Future<void> showDailyAtTime() async {
    var time = Time(18, 37, 00);
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
      'Bacchusからのお知らせ',
      '飲酒管理は毎日の飲酒量の見える化から', //null
      time,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  final bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  sharedDate.toInvalidDate();
  showDailyAtTime();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var isUserLogin = _auth.currentUser?.uid ?? false;
    const locale = Locale("ja", "JP");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        locale,
      ],
      routes: {
        '/main': (context) => mainScreen(_routeObserver),
        '/personal': (context) => personalScreen(),
        '/preset': (context) => presetScreen(),
        '/list': (context) => listScreen(),
        '/editPreset': (context) => editPreset(),
        '/editDrink': (context) => editDrink(),
        '/login': (context) => loginScreen(),
        '/kiyaku': (context) => WebScreen(),
        '/policy': (context) => WebScreen2(),
      },
      navigatorObservers: [
        _routeObserver,
      ],
      home: isUserLogin == false ? loginScreen() : mainScreen(_routeObserver),
    );
  }
}
