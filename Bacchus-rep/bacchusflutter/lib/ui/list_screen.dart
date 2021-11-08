import 'package:bacchusflutter/model/drink_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class listScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('listScreen');
    CollectionReference drinkData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('DrinkData');
    DateTime now = DateTime.now();

    Future<dynamic> deleteDrink(Timestamp timestamp) async {
      var snapshot =
          await drinkData.where('timestamp', isEqualTo: timestamp).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return;
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/main');
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('この1週間に飲んだお酒リスト'),
        ),
        body: Center(
          child: ChangeNotifierProvider(
            create: (_) => DrinkModel()..getDrinkList(),
            child: Consumer<DrinkModel>(
              builder: (context, model, child) {
                final drinkList = model.list;
                return ListView.builder(
                  itemCount: drinkList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var dateFormat = DateFormat('MM/dd HH:mm:ss');
                    return Dismissible(
                        key: Key(dateFormat
                            .format(drinkList[index].timestamp.toDate())),
                        background: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          // スワイプ後に実行される（削除処理などを書く）
                          deleteDrink(drinkList[index].timestamp).catchError(
                              (error) =>
                                  print("Failed to delete drinkData: $error"));

                          print('onDismissed');
                        },
                        child: Container(
                          height: 80,
                          child: Card(
                              child: ListTile(
                            title: Text(dateFormat.format(
                                    drinkList[index].timestamp.toDate()) +
                                '  ' +
                                drinkList[index].name),
                            subtitle: Text(
                                drinkList[index].amount.toString().padLeft(3) +
                                    'ml ' +
                                    drinkList[index]
                                        .percent
                                        .toStringAsFixed(1)
                                        .padLeft(4) +
                                    '% ' +
                                    'アルコール摂取量 ' +
                                    drinkList[index]
                                        .alcAmount
                                        .toStringAsFixed(1)
                                        .padLeft(5) +
                                    'g'),
                            onTap: () =>
                                Navigator.pushNamed(context, '/editDrink',
                                    arguments: DrinkData(
                                      drinkList[index].timestamp,
                                      drinkList[index].name,
                                      drinkList[index].amount.toInt(),
                                      drinkList[index].percent.toDouble(),
                                      drinkList[index].alcAmount.toDouble(),
                                    )),
                          )),
                        ));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
