import 'package:bacchusflutter/model/preset_model.dart';
import 'package:bacchusflutter/ui/input_preset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class presetScreen extends StatelessWidget {
  presetScreen({Key? key}) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('presetScreen');
    CollectionReference presetData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('PresetData');

    // Future<dynamic> editPreset(String name, int amount, double percent) {
    //   return presetData
    //       .doc()
    //       .update({
    //         'name': name,
    //         'amount': amount,
    //         'percent': percent,
    //       })
    //       .then((value) => Navigator.push(
    //           context, MaterialPageRoute(builder: (context) => presetScreen())))
    //       .catchError((error) => print("Failed to add drinkData: $error"));
    // }

    Future<dynamic> deletePreset(String name) async {
      var snapshot = await presetData.where('name', isEqualTo: name).get();
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
          title: Text('プリセットデータ編集'),
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
                    return Dismissible(
                      key: Key(presetList[index].name),
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
                        deletePreset(presetList[index].name)
                            .then((value) => print('onDismissed'))
                            .catchError((error) =>
                                print("Failed to delete presetData: $error"));
                      },
                      child: Container(
                          height: 70,
                          child: Card(
                              child: ListTile(
                            title: Text(presetList[index].name),
                            subtitle: Text(
                                presetList[index].amount.toString().padLeft(3) +
                                    'ml' +
                                    '\t' +
                                    presetList[index]
                                        .percent
                                        .toString()
                                        .padLeft(4) +
                                    '%'),
                            onTap: () => Navigator.pushNamed(
                                context, '/editPreset',
                                arguments: PresetData(
                                    presetList[index].name,
                                    presetList[index].amount.toInt(),
                                    presetList[index].percent.toDouble())),
                          ))),
                    );
                  },
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => inputPreset()));
          },
        ),
      ),
    );
  }
}
