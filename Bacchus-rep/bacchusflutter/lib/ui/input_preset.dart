import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class inputPreset extends StatelessWidget {
  const inputPreset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'プリセットデータ追加';
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: inputPresetPage(),
    );
  }
}

class inputPresetPage extends StatefulWidget {
  @override
  inputPresetPageState createState() {
    return inputPresetPageState();
  }
}

class inputPresetPageState extends State<inputPresetPage> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('inputPresetPageState');
    CollectionReference presetData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PresetData');

    Future<dynamic> addPreset(String name, int amount, double percent) {
      return presetData
          .add({
            'name': name,
            'amount': amount,
            'percent': percent,
          })
          .then((value) => Navigator.pushReplacementNamed(context, '/preset'))
          .catchError((error) => print("Failed to add presetData: $error"));
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
                  border: UnderlineInputBorder(), labelText: 'プリセットデータ名'),
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
                      addPreset(
                          myController.text,
                          int.parse(myController2.text),
                          double.parse(myController3.text));
                    }
                  },
                  child: const Text('プリセットを追加する'),
                ))
          ],
        ),
      ),
    );
  }
}
