import 'package:bacchusflutter/model/main_model.dart';
import 'package:bacchusflutter/ui/input_drink_scratch.dart';
import 'package:bacchusflutter/utils/init_preset.dart';
import 'package:bacchusflutter/utils/shared_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'indicator.dart';
import 'input_drink_preset.dart';

class mainScreen extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;
  const mainScreen(this.routeObserver);
  @override
  mainScreenState createState() => mainScreenState();
}

class mainScreenState extends State<mainScreen> with RouteAware {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int touchedIndex = -1;
  DateTime _selected = DateTime.now();
  var pushOk = true;

  @override
  Widget build(BuildContext context) {
    print('mainScreen');
    getSelectedDate();
    return WillPopScope(
        onWillPop: () {
          bool isDrawerOpen = _key.currentState!.isDrawerOpen;
          if (isDrawerOpen) {
            Navigator.pop(context);
            return Future.value(false); // 画面遷移をさせない
          } else {
            return Future.value(true); // 画面遷移を許可
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('飲酒データグラフ'),
          ),
          body: ChangeNotifierProvider(
              create: (_) => MainModel()..getMainList(),
              child: Consumer<MainModel>(builder: (context, model, child) {
                final datas = model.MainList;
                // if (datas[0].name != 'name' &&
                //     datas[0].isInit == false &&
                //     pushOk) {
                //   Navigator.pushReplacementNamed(context, '/personal');
                //   pushOk = false;
                // }
                if (datas[0].name != 'name' && datas[0].isPresetInit == false) {
                  InitPreset.initPresetData(context);
                }
                return Column(children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Indicator(
                          color: Colors.amber,
                          text: '1日のアルコール摂取量',
                          isSquare: false,
                          size: touchedIndex == 0 ? 18 : 16,
                          textColor:
                              touchedIndex == 0 ? Colors.black : Colors.grey,
                        ),
                        Indicator(
                          color: Colors.cyan,
                          text: '過去7日間の累積アルコール摂取量の平均値',
                          isSquare: false,
                          size: touchedIndex == 1 ? 18 : 16,
                          textColor:
                              touchedIndex == 1 ? Colors.black : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 480,
                    padding: const EdgeInsets.all(16),
                    child: BarChart(BarChartData(
                        borderData: FlBorderData(
                            border: Border(
                          top: BorderSide.none,
                          right: BorderSide.none,
                          left: BorderSide(width: 1),
                          bottom: BorderSide(width: 1),
                        )),
                        barTouchData: BarTouchData(touchCallback:
                            (FlTouchEvent event, barTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                barTouchResponse == null ||
                                barTouchResponse.spot == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                barTouchResponse.spot!.touchedBarGroupIndex;
                          });
                        }),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(
                              showTitles: true,
                              getTitles: (double value) {
                                switch (value.toInt()) {
                                  case 1:
                                    return datas[0].name;
                                  case 2:
                                    return datas[1].name;
                                  case 3:
                                    return datas[2].name;
                                  case 4:
                                    return datas[3].name;
                                  case 5:
                                    return datas[4].name;
                                  case 6:
                                    return datas[5].name;
                                  case 7:
                                    return datas[6].name;
                                  default:
                                    return ' ';
                                }
                              }),
                        ),
                        groupsSpace: 10,
                        minY: 0,
                        barGroups: [
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                                y: datas[0].amount,
                                width: 15,
                                colors: [Colors.amber]),
                            BarChartRodData(
                                y: datas[0].average,
                                width: 15,
                                colors: [Colors.cyan]),
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(
                                y: datas[1].amount,
                                width: 15,
                                colors: [Colors.amber]),
                            BarChartRodData(
                                y: datas[1].average,
                                width: 15,
                                colors: [Colors.cyan]),
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(
                                y: datas[2].amount,
                                width: 15,
                                colors: [Colors.amber]),
                            BarChartRodData(
                                y: datas[2].average,
                                width: 15,
                                colors: [Colors.cyan]),
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(
                                y: datas[3].amount,
                                width: 15,
                                colors: [Colors.amber]),
                            BarChartRodData(
                                y: datas[3].average,
                                width: 15,
                                colors: [Colors.cyan]),
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(
                                y: datas[4].amount,
                                width: 15,
                                colors: [Colors.amber]),
                            BarChartRodData(
                                y: datas[4].average,
                                width: 15,
                                colors: [Colors.cyan]),
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(
                                y: datas[5].amount,
                                width: 15,
                                colors: [Colors.amber]),
                            BarChartRodData(
                                y: datas[5].average,
                                width: 15,
                                colors: [Colors.cyan]),
                          ]),
                          BarChartGroupData(x: 7, barRods: [
                            BarChartRodData(
                                y: datas[6].amount,
                                width: 15,
                                colors: [Colors.amber]),
                            BarChartRodData(
                                y: datas[6].average,
                                width: 15,
                                colors: [Colors.cyan]),
                          ]),
                        ])),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      width: 320,
                      child: printAdvice(
                        datas.isNotEmpty ? datas[0].limitADay : 10,
                        datas.isNotEmpty ? datas[0].limitAWeek : 50,
                        datas.isNotEmpty ? datas[0].limitAWeekAvg : 50,
                        datas.isNotEmpty ? datas[0].alcAmount : 0,
                        datas.isNotEmpty ? datas[0].alcAmountYesterday : 0,
                        datas.isNotEmpty ? datas[0].alcAmountAvg : 0,
                      )),
                  Container(
                    child: Text('日付' + (DateFormat.yMMMd()).format(_selected)),
                  ),
                ]);
              })),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                var result = await showDialog<int>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('入力方法を選択'),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => inputDrinkScratch())),
                          child: const Text('スクラッチ入力'),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => inputDrinkPreset())),
                          child: const Text('プリセット入力'),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('キャンセル'),
                        )
                      ],
                    );
                  },
                );
              }),
          drawer: Drawer(
            child: ListView(children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Bacchus',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('個人設定'),
                onTap: () => Navigator.pushNamed(context, '/personal'),
              ),
              ListTile(
                title: Text('プリセット編集'),
                onTap: () => Navigator.pushNamed(context, '/preset'),
              ),
              ListTile(
                title: Text('リスト表示'),
                onTap: () => Navigator.pushNamed(context, '/list'),
              ),
              ListTile(
                title: Text('日付切り替え'),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text('プリセット初期化'),
                onTap: () => InitPreset.initPresetData(context),
              ),
              ListTile(
                  title: Text('ログアウトする'),
                  onTap: () {
                    signOut(context);
                  }),
            ]),
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 上の画面がpopされて、この画面に戻ったときに呼ばれます
  void didPopNext() {
    debugPrint("didPopNext ${runtimeType}");
  }

  // この画面がpushされたときに呼ばれます
  void didPush() {
    debugPrint("didPush ${runtimeType}");
  }

  // この画面がpopされたときに呼ばれます
  void didPop() {
    debugPrint("didPop ${runtimeType}");
  }

  // この画面から新しい画面をpushしたときに呼ばれます
  void didPushNext() {
    debugPrint("didPushNext ${runtimeType}");
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  Widget printAdvice(var limitAday, var limitAweek, var limitAweekAvg,
      var alcAmount, var alcAmountYesterday, var alcAmountAvg) {
    {
      print(limitAday.toString());
      print(limitAweek.toString());
      print(limitAweekAvg.toString());
      print(alcAmount.toString());
      print(alcAmountYesterday.toString());
      print(alcAmountAvg.toString());
      if (alcAmount == 0.0 &&
          (alcAmountAvg >= limitAweekAvg ||
              alcAmountYesterday >= limitAday.toDouble() * 1.5)) {
        return Text(
          '今日は休肝日を推奨します',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (alcAmountAvg >= limitAweekAvg ||
          alcAmount >= limitAday.toDouble() * 1.5) {
        return Text(
          '明日は休肝日を推奨します',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (alcAmount >= limitAday.toDouble() * 0.8) {
        return Text(
          '今日はこの辺にしておきましょう',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (alcAmount == 0.0) {
        return Text(
          'お酒はたしなむ程度が健康の秘訣',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Text(
          'これくらいの量が適量です',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Hiranogi Kaku Gothic ProN'),
        );
      }
    }
    ;
  }

  getSelectedDate() async {
    DateTime selected;

    selected = await sharedDate.loadDate();
    _selected = selected;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: await sharedDate.loadDate(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    sharedDate.saveDate(selected!.year, selected.month, selected.day);
    Navigator.pushReplacementNamed(context, '/main');
  }
}
