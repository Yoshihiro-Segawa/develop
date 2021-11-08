import 'package:bacchusflutter/utils/shared_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MainModel extends ChangeNotifier {
  List<MainData> MainList = []
    ..add(MainData(
      name: 'name',
      amount: 0.0,
      average: 0.0,
      isInit: false,
      isPresetInit: false,
      isPremium: false,
      limitADay: 0,
      limitAWeek: 0,
      limitAWeekAvg: 0.0,
      noAlcDayAWeek: 2,
      alcAmount: 0.0,
      alcAmountYesterday: 0.0,
      alcAmountAvg: 0.0,
    ))
    ..add(MainData(
      name: 'name',
      amount: 0.0,
      average: 0.0,
      isInit: false,
      isPresetInit: false,
      isPremium: false,
      limitADay: 0,
      limitAWeek: 0,
      limitAWeekAvg: 0.0,
      noAlcDayAWeek: 2,
      alcAmount: 0.0,
      alcAmountYesterday: 0.0,
      alcAmountAvg: 0.0,
    ))
    ..add(MainData(
      name: 'name',
      amount: 0.0,
      average: 0.0,
      isInit: false,
      isPresetInit: false,
      isPremium: false,
      limitADay: 0,
      limitAWeek: 0,
      limitAWeekAvg: 0.0,
      noAlcDayAWeek: 2,
      alcAmount: 0.0,
      alcAmountYesterday: 0.0,
      alcAmountAvg: 0.0,
    ))
    ..add(MainData(
      name: 'name',
      amount: 0.0,
      average: 0.0,
      isInit: false,
      isPresetInit: false,
      isPremium: false,
      limitADay: 0,
      limitAWeek: 0,
      limitAWeekAvg: 0.0,
      noAlcDayAWeek: 2,
      alcAmount: 0.0,
      alcAmountYesterday: 0.0,
      alcAmountAvg: 0.0,
    ))
    ..add(MainData(
      name: 'name',
      amount: 0.0,
      average: 0.0,
      isInit: false,
      isPresetInit: false,
      isPremium: false,
      limitADay: 0,
      limitAWeek: 0,
      limitAWeekAvg: 0.0,
      noAlcDayAWeek: 2,
      alcAmount: 0.0,
      alcAmountYesterday: 0.0,
      alcAmountAvg: 0.0,
    ))
    ..add(MainData(
      name: 'name',
      amount: 0.0,
      average: 0.0,
      isInit: false,
      isPresetInit: false,
      isPremium: false,
      limitADay: 0,
      limitAWeek: 0,
      limitAWeekAvg: 0.0,
      noAlcDayAWeek: 2,
      alcAmount: 0.0,
      alcAmountYesterday: 0.0,
      alcAmountAvg: 0.0,
    ))
    ..add(MainData(
      name: 'name',
      amount: 0.0,
      average: 0.0,
      isInit: false,
      isPresetInit: false,
      isPremium: false,
      limitADay: 0,
      limitAWeek: 0,
      limitAWeekAvg: 0.0,
      noAlcDayAWeek: 2,
      alcAmount: 0.0,
      alcAmountYesterday: 0.0,
      alcAmountAvg: 0.0,
    ));
  List<double> data = List.filled(14, 0.0);

  final auth = FirebaseAuth.instance;
  void getMainList() async {
    var now = DateTime.now();
    var today = await sharedDate.loadDate();
    //var today = DateTime(now.year, now.month, now.day, 0, 0);
    final userId = auth.currentUser!.uid;
    CollectionReference drinkData = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('DrinkData');
    CollectionReference personalData = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('PersonalData');

    var snapshot = await personalData.get();
    for (var doc in snapshot.docs) {
      MainList[0].isInit = doc['isinit'];
      MainList[0].isPresetInit = doc['ispresetinit'];
      MainList[0].isPremium = doc['ispremium'];
      MainList[0].limitADay = doc['limit_aday'];
      MainList[0].limitAWeek = doc['limit_aweek'];
      MainList[0].noAlcDayAWeek = doc['noalcday_aweek'];
      MainList[0].limitAWeekAvg =
          MainList[0].limitAWeek.toDouble() / (7.0 - MainList[0].noAlcDayAWeek);
    }
    for (var i = -12; i <= 0; i++) {
      var snapshot = await drinkData
          .where('timestamp',
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(today.add(Duration(days: i))))
          .where('timestamp',
              isLessThan: Timestamp.fromDate(today.add(Duration(days: i + 1))))
          .get();
      for (var doc in snapshot.docs) {
        data[i + 12] += (doc['alcAmount']);
      }
    }
    for (var i = 0; i < 7; i++) {
      MainList[i].name =
          DateFormat('MM/dd').format(today.add(Duration(days: i - 6)));
      MainList[i].amount = data[i + 6];
      MainList[i].average = await (data[i] +
              data[i + 1] +
              data[i + 2] +
              data[i + 3] +
              data[i + 4] +
              data[i + 5] +
              data[i + 6]) /
          (7 - MainList[0].noAlcDayAWeek);
      MainList[0].alcAmount = data[12];
      MainList[0].alcAmountYesterday = data[11];
      MainList[0].alcAmountAvg = MainList[6].average;
      print(MainList[i].name +
          ' ' +
          MainList[i].amount.toString() +
          ' ' +
          MainList[i].average.toString());
    }
    notifyListeners();
  }
}

class MainData {
  String name;
  double amount;
  double average;
  bool isInit;
  bool isPresetInit;
  bool isPremium;
  int limitADay;
  int limitAWeek;
  double limitAWeekAvg;
  int noAlcDayAWeek;
  double alcAmount;
  double alcAmountYesterday;
  double alcAmountAvg;

  MainData({
    required this.name,
    required this.amount,
    required this.average,
    required this.isInit,
    required this.isPresetInit,
    required this.isPremium,
    required this.limitADay,
    required this.limitAWeek,
    required this.limitAWeekAvg,
    required this.noAlcDayAWeek,
    required this.alcAmount,
    required this.alcAmountYesterday,
    required this.alcAmountAvg,
  });
}
