import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresetModel extends ChangeNotifier {
  List<PresetData> list = [];
  final auth = FirebaseAuth.instance;

  Future getPresetList() async {
    final collection = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PresetData')
        .orderBy('name')
        .get();
    list = collection.docs
        .map((doc) => PresetData(
              doc['name'],
              doc['amount'],
              doc['percent'],
            ))
        .toList();
    notifyListeners();
  }
}

class PresetData {
  PresetData(
    this.name,
    this.amount,
    this.percent,
  );
  String name;
  int amount;
  double percent;
}
