import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitPreset {
  static Future initPresetData(BuildContext context) async {
    List<InitPresetData> list = []
      ..add(InitPresetData(false, '生ビール中ジョッキ', 350, 5.0))
      ..add(InitPresetData(false, 'ワイン グラス', 125, 12.5))
      ..add(InitPresetData(false, 'ウィスキー水割り25', 25, 45.0))
      ..add(InitPresetData(false, '日本酒１合', 180, 15.0))
      ..add(InitPresetData(false, '焼酎お湯割り', 50, 25.0))
      ..add(InitPresetData(false, '泡盛ストレート', 100, 45.0))
      ..add(InitPresetData(false, 'ハイボール中ジョッキ', 350, 6.0))
      ..add(InitPresetData(false, 'レモンサワー中ジョッキ', 350, 3.0))
      ..add(InitPresetData(false, '缶ビール', 350, 5.0))
      ..add(InitPresetData(false, '缶チューハイ', 350, 7.0));

    final auth = FirebaseAuth.instance;

    CollectionReference presetData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PresetData');
    CollectionReference personalData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PersonalData');

    for (var entry in list) {
      var snapshot =
          await presetData.where('name', isEqualTo: entry.name).get();
      for (var doc in snapshot.docs) {
        entry.isValid = true;
      }
    }
    for (var entry in list) {
      if (entry.isValid == false) {
        presetData
            .add({
              'name': entry.name,
              'amount': entry.amount,
              'percent': entry.percent,
            })
            .then((value) => print(entry.name +
                ' ' +
                entry.amount.toString() +
                ' ' +
                entry.percent.toString()))
            .catchError((error) => print("Failed to add presetData: $error"));
      }
    }

    var snapshot2 = await personalData.get();
    final snackBar = SnackBar(content: Text('プリセットデータを初期化しました'));
    for (var doc in snapshot2.docs) {
      await doc.reference
          .set({
            'ispresetinit': true,
          }, SetOptions(merge: true))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar))
          .catchError(
              (error) => print("Failed to update personalData: $error"));
    }
  }
}

class InitPresetData {
  InitPresetData(this.isValid, this.name, this.amount, this.percent);
  bool isValid;
  String name;
  int amount;
  double percent;
}
