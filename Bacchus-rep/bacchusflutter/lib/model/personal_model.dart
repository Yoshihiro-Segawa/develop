import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PersonalModel extends ChangeNotifier {
  List<PersonalData> PersonalList = [];

  final auth = FirebaseAuth.instance;

  Future getPersonalData() async {
    final collection = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PersonalData')
        .get();
    PersonalList = collection.docs
        .map((doc) => PersonalData(
              doc['isinit'],
              doc['ispresetinit'],
              doc['ispremium'],
              doc['nickname'],
              doc['gender'],
              doc['strictness'],
              doc['age'],
              doc['limit_aday'],
              doc['limit_aweek'],
              doc['noalcday_aweek'],
            ))
        .toList();
    notifyListeners();
  }
}

class PersonalData {
  bool isInit;
  bool isPresetInit;
  bool isPremium;
  String nickname;
  String gender;
  String strictness;
  int age;
  int limitADay;
  int limitAWeek;
  int noAlcDayAWeek;

  PersonalData(
    this.isInit,
    this.isPresetInit,
    this.isPremium,
    this.nickname,
    this.gender,
    this.strictness,
    this.age,
    this.limitADay,
    this.limitAWeek,
    this.noAlcDayAWeek,
  );
}
