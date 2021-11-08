import 'package:bacchusflutter/model/drink_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class editDrink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)!.settings.arguments;
    final DrinkData data = args as DrinkData;
    final appTitle = '飲酒データ変更';

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: editDrinkPage(
        data: data,
      ),
    );
  }
}

class editDrinkPage extends StatefulWidget {
  final DrinkData data;
  editDrinkPage({required this.data});
  @override
  editDrinkPageState createState() {
    return editDrinkPageState();
  }
}

class editDrinkPageState extends State<editDrinkPage> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('editDrinkPageState');
    CollectionReference drinkData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('DrinkData');

    Future<dynamic> updateDrink(
        Timestamp timestamp, String name, int amount, double percent) async {
      var snapshot =
          await drinkData.where('timestamp', isEqualTo: timestamp).get();
      for (var doc in snapshot.docs) {
        await doc.reference
            .update({
              'name': name,
              'amount': amount,
              'percent': percent,
              'alcAmount': amount * percent * 0.009,
            })
            .then((value) => Navigator.pushReplacementNamed(context, '/list'))
            .catchError((error) => print("Failed to update drinkData: $error"));
      }
    }

    var myController = TextEditingController(text: widget.data.name);
    var myController2 =
        TextEditingController(text: widget.data.amount.toString());
    var myController3 =
        TextEditingController(text: widget.data.percent.toString());

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
                      updateDrink(
                          widget.data.timestamp,
                          myController.text,
                          int.parse(myController2.text),
                          double.parse(myController3.text));
                    }
                  },
                  child: const Text('飲酒データを変更する'),
                ))
          ],
        ),
      ),
    );
  }
}
