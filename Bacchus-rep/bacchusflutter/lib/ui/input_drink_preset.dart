import 'package:bacchusflutter/model/preset_model.dart';
import 'package:bacchusflutter/utils/shared_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class inputDrinkPreset extends StatelessWidget {
  inputDrinkPreset({Key? key}) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('inputDrinkPreset');
    CollectionReference drinkData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('DrinkData');
    DateTime now = DateTime.now();

    sharedDate.toInvalidDate();
    Future<dynamic> addDrink(String name, int amount, double percent) {
      return drinkData
          .add({
            'timestamp': Timestamp.fromDate(now),
            'name': name,
            'amount': amount,
            'percent': percent,
            'alcAmount': amount * percent * 0.009,
          })
          .then((value) => Navigator.pushReplacementNamed(context, '/main'))
          .catchError((error) => print("Failed to add drinkData: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("プリセット入力"),
      ),
      body: Center(
        child: ChangeNotifierProvider(
          create: (_) => PresetModel()..getPresetList(),
          child: Consumer<PresetModel>(
            builder: (context, model, child) {
              final presetList = model.list;
              return ListView.builder(
                itemCount: presetList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70,
                    child: Card(
                      child: ListTile(
                        title: Text(presetList[index].name),
                        subtitle: Text(presetList[index]
                                .amount
                                .toString()
                                .padLeft(3) +
                            'ml' +
                            '\t' +
                            presetList[index].percent.toString().padLeft(4) +
                            '%'),
                        onTap: () => addDrink(
                          presetList[index].name,
                          presetList[index].amount.toInt(),
                          presetList[index].percent.toDouble(),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
