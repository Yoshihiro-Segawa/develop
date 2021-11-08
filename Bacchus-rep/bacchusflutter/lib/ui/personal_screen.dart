import 'package:bacchusflutter/model/personal_model.dart';
import 'package:bacchusflutter/utils/init_preset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class personalScreen extends StatelessWidget {
  const personalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = '個人設定';
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: personalInput(),
    );
  }
}

class personalInput extends StatefulWidget {
  @override
  personalInputState createState() {
    return personalInputState();
  }
}

enum Gender { Female, Male, NotSet }
enum Strictness { Strict, ALittleLoose, Loose, NotSet }

class personalInputState extends State<personalInput> {
  final _formKey = GlobalKey<FormState>();
  Gender _gGender = Gender.NotSet;
  Strictness _gStrictness = Strictness.NotSet;
  var init = 0;
  var limitADay = 0;
  var limitAWeek = 0;
  var noAlcDayAWeek = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController myController = TextEditingController();
  TextEditingController myController2 = TextEditingController();

  void setNotification() async {
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            // sound: 'example.mp3',
            presentAlert: true,
            presentBadge: true,
            presentSound: true);
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: null,
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'title', 'body', platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    print('personalInput');
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference personalData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PersonalData');

    //setNotification();
    Future<dynamic> addPersonal(
        String nickname,
        String gender,
        String strictness,
        int age,
        int limitADay,
        int limitAWeek,
        int noAlcDayAWeek) async {
      await personalData
          .doc('Personal')
          .set({
            'isinit': true,
            'ispresetinit': true, // 初期化されているはずなのでコード変更に注意
            'ispremium': false,
            'nickname': nickname,
            'gender': gender,
            'strictness': strictness,
            'age': age,
            'limit_aday': limitADay,
            'limit_aweek': limitAWeek,
            'noalcday_aweek': noAlcDayAWeek,
          }, SetOptions(merge: true))
          .then((value) => Navigator.pushReplacementNamed(context, '/main'))
          .catchError((error) => print("Failed to add personalData: $error"));
    }

    Future<dynamic> setPersonal(
        String nickname,
        String gender,
        String strictness,
        int age,
        int limitADay,
        int limitAWeek,
        int noAlcDayAWeek) async {
      var snapshot = await personalData.get();
      for (var doc in snapshot.docs) {
        await doc.reference
            .update({
              'isinit': true,
              'nickname': nickname,
              'gender': gender,
              'strictness': strictness,
              'age': age,
              'limit_aday': limitADay,
              'limit_aweek': limitAWeek,
              'noalcday_aweek': noAlcDayAWeek,
            })
            .then((value) => Navigator.pushReplacementNamed(context, '/main'))
            .catchError((error) => print("Failed to set personalData: $error"));
      }
      Navigator.pushReplacementNamed(context, '/main');
    }

    return ChangeNotifierProvider(
      create: (_) => PersonalModel()..getPersonalData(),
      child: Consumer<PersonalModel>(
        builder: (context, model, child) {
          final personalData = model.PersonalList;
          var gender = personalData.isNotEmpty
              ? personalData.elementAt(0).gender
              : 'NotSet';
          var strictness = personalData.isNotEmpty
              ? personalData.elementAt(0).strictness
              : 'NotSet';
          if (personalData.isNotEmpty && (init++ == 0)) {
            _gGender = (gender == 'Female') ? Gender.Female : Gender.Male;
            switch (strictness) {
              case "Strict":
                _gStrictness = Strictness.Strict;
                break;
              case "ALittleLoose":
                _gStrictness = Strictness.ALittleLoose;
                break;
              case "Loose":
                _gStrictness = Strictness.Loose;
                break;
              default:
                _gStrictness = Strictness.NotSet;
                break;
            }
            myController =
                TextEditingController(text: personalData.elementAt(0).nickname);
            myController2 = TextEditingController(
                text: personalData.elementAt(0).age.toString());

            if ((personalData.isNotEmpty &&
                    (personalData.elementAt(0).isPresetInit == false)) ||
                personalData.isEmpty) {
              InitPreset.initPresetData(context);
            }
            limitADay = personalData.isNotEmpty
                ? personalData.elementAt(0).limitADay
                : 0;
            limitAWeek = personalData.isNotEmpty
                ? personalData.elementAt(0).limitAWeek
                : 0;
            noAlcDayAWeek = personalData.isNotEmpty
                ? personalData.elementAt(0).noAlcDayAWeek
                : 0;
          }
          setDefaultLimit();
          return Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'ニックネーム',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ニックネームを入力してください';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Text('性別'),
                      Radio<Gender>(
                        value: Gender.Female,
                        groupValue: _gGender,
                        onChanged: (Gender? value) => setState(() {
                          _gGender = value!;
                        }),
                      ),
                      Text('女性'),
                      Radio<Gender>(
                        value: Gender.Male,
                        groupValue: _gGender,
                        onChanged: (Gender? value) => setState(() {
                          _gGender = value!;
                        }),
                      ),
                      Text('男性'),
                    ],
                  ),
                  TextFormField(
                    controller: myController2,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(), labelText: '年齢'),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '年齢を入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('節酒の厳格さ'),
                  Container(
                    height: 40,
                    child: RadioListTile(
                      title: Text('厳格（厚労省推奨値)'),
                      value: Strictness.Strict,
                      groupValue: _gStrictness,
                      onChanged: (Strictness? value) => setState(() {
                        _gStrictness = value!;
                      }),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: RadioListTile(
                      title: Text('若干ゆるめ'),
                      value: Strictness.ALittleLoose,
                      groupValue: _gStrictness,
                      onChanged: (Strictness? value) => setState(() {
                        _gStrictness = value!;
                      }),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: RadioListTile(
                      title: Text('ゆるめ'),
                      value: Strictness.Loose,
                      groupValue: _gStrictness,
                      onChanged: (Strictness? value) => setState(() {
                        _gStrictness = value!;
                      }),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('性別と節酒の厳格さから求まる目標値'),
                  SizedBox(height: 10),
                  Text(
                    '１日上限アルコール量(g)       ' + limitADay.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '１週間上限アルコール量(g)  ' + limitAWeek.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '１週間中の休肝日数                 ' + noAlcDayAWeek.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                            onPressed: () {
                              gender = (_gGender == Gender.Female)
                                  ? 'Female'
                                  : 'Male';
                              switch (_gStrictness) {
                                case Strictness.Strict:
                                  strictness = 'Strict';
                                  break;
                                case Strictness.ALittleLoose:
                                  strictness = 'ALittleLoose';
                                  break;
                                case Strictness.Loose:
                                  strictness = 'Loose';
                                  break;
                                default:
                                  strictness = 'NotSet';
                                  break;
                              }

                              if (_formKey.currentState!.validate()) {
                                if (personalData.isNotEmpty &&
                                    (personalData[0].isInit == true)) {
                                  setPersonal(
                                    myController.text,
                                    gender,
                                    strictness,
                                    int.parse(myController2.text),
                                    limitADay,
                                    limitAWeek,
                                    noAlcDayAWeek,
                                  );
                                } else {
                                  addPersonal(
                                    myController.text,
                                    gender,
                                    strictness,
                                    int.parse(myController2.text),
                                    limitADay,
                                    limitAWeek,
                                    noAlcDayAWeek,
                                  );
                                }
                              } else {
                                print(
                                    '_formKey.currentState!.validate() error');
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 100),
                              child: Text('設定完了'),
                            )),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void setDefaultLimit() {
    switch (_gGender) {
      case Gender.Female:
        switch (_gStrictness) {
          case Strictness.Strict:
            limitADay = 10;
            limitAWeek = 50;
            noAlcDayAWeek = 2;
            break;
          case Strictness.ALittleLoose:
            limitADay = 20;
            limitAWeek = 120;
            noAlcDayAWeek = 1;
            break;
          case Strictness.Loose:
            limitADay = 40;
            limitAWeek = 240;
            noAlcDayAWeek = 1;
            break;
          default:
            limitADay = 10;
            limitAWeek = 50;
            noAlcDayAWeek = 2;
            break;
        }
        break;
      case Gender.Male:
        switch (_gStrictness) {
          case Strictness.Strict:
            limitADay = 20;
            limitAWeek = 100;
            noAlcDayAWeek = 2;
            break;
          case Strictness.ALittleLoose:
            limitADay = 40;
            limitAWeek = 240;
            noAlcDayAWeek = 1;
            break;
          case Strictness.Loose:
            limitADay = 60;
            limitAWeek = 360;
            noAlcDayAWeek = 1;
            break;
          default:
            limitADay = 20;
            limitAWeek = 100;
            noAlcDayAWeek = 2;
            break;
        }
        break;
      default:
        limitADay = 10;
        limitAWeek = 50;
        noAlcDayAWeek = 2;
        break;
    }
  }
}
