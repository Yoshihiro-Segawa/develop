import 'package:bacchusflutter/utils/shared_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DrinkModel extends ChangeNotifier {
  List<DrinkData> list = [];
  final auth = FirebaseAuth.instance;

  Future getDrinkList() async {
    var today = await sharedDate.loadDate();
    final userId = auth.currentUser!.uid;
    final collection = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('DrinkData')
        .orderBy('timestamp', descending: true)
        .where('timestamp',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(today.add(Duration(days: -6))))
        .where('timestamp',
            isLessThan: Timestamp.fromDate(today.add(Duration(days: 1))))
        .get();
    list = collection.docs
        .map((doc) => DrinkData(
              doc['timestamp'],
              doc['name'],
              doc['amount'],
              doc['percent'],
              doc['alcAmount'],
            ))
        .toList();
    notifyListeners();
  }
}

class DrinkData {
  DrinkData(
    this.timestamp,
    this.name,
    this.amount,
    this.percent,
    this.alcAmount,
  );
  Timestamp timestamp;
  String name;
  int amount;
  double percent;
  double alcAmount;
}
