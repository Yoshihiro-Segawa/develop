import 'package:bacchusflutter/utils/shared_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class inputDrinkScratch extends StatelessWidget {
  const inputDrinkScratch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'スクラッチ入力';
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: inputScratch(),
    );
  }
}

class inputScratch extends StatefulWidget {
  @override
  inputScratchState createState() {
    return inputScratchState();
  }
}

class inputScratchState extends State<inputScratch> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('inputScratchState');
    CollectionReference drinkData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('DrinkData');
    DateTime now = DateTime.now();

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

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: myController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), labelText: '飲酒データ名'),
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return '飲酒データ名を入力してください';
                }
                return null;
              },
            ),
            TextFormField(
                controller: myController2,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: '飲酒量(ml)'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return '飲酒量を入力してください';
                  }
                  return null;
                }),
            TextFormField(
                controller: myController3,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'アルコール度数(%)'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'アルコール度数を入力してください';
                  }
                  return null;
                }),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sharedDate.toInvalidDate();
                      addDrink(myController.text, int.parse(myController2.text),
                          double.parse(myController3.text));
                    }
                  },
                  child: const Text('追加する'),
                ))
          ],
        ),
      ),
    );
  }
}
