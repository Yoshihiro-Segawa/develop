import 'package:bacchusflutter/model/preset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class editPreset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)!.settings.arguments;
    final PresetData data = args as PresetData;
    final appTitle = 'プリセットデータ変更';
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: editPresetPage(
        data: data,
      ),
    );
  }
}

class editPresetPage extends StatefulWidget {
  final PresetData data;
  editPresetPage({required this.data});
  @override
  editPresetPageState createState() {
    return editPresetPageState();
  }
}

class editPresetPageState extends State<editPresetPage> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('editPresetPageState');
    CollectionReference presetData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PresetData');

    Future<dynamic> updatePreset(
        String oldName, String name, int amount, double percent) async {
      var snapshot = await presetData.where('name', isEqualTo: oldName).get();
      for (var doc in snapshot.docs) {
        await doc.reference
            .update({
              'name': name,
              'amount': amount,
              'percent': percent,
            })
            .then((value) => Navigator.pushReplacementNamed(context, '/preset'))
            .catchError(
                (error) => print("Failed to update presetData: $error"));
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
                  border: UnderlineInputBorder(), labelText: 'プリセットデータ名'),
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'プリセットデータ名を入力してください';
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
                      updatePreset(
                          widget.data.name,
                          myController.text,
                          int.parse(myController2.text),
                          double.parse(myController3.text));
                    }
                  },
                  child: const Text('プリセットを変更する'),
                ))
          ],
        ),
      ),
    );
  }
}
