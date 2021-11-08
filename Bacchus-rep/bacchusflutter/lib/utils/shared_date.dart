import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sharedDate {
  static Future<DateTime> loadDate() async {
    DateTime result = DateTime.now();
    final _dateFormatter = DateFormat('y/M/d');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isValid = prefs.getBool('isSelectValid') ?? false;
    if (isValid) {
      int year = prefs.getInt('selectYear') ?? 2021;
      int month = prefs.getInt('selectMonth') ?? 11;
      int day = prefs.getInt('selectDay') ?? 1;
      try {
        result = _dateFormatter.parseStrict('$year/$month/$day');
      } catch (e) {}
    } else {
      var now = DateTime.now();
      result = DateTime(now.year, now.month, now.day, 0, 0);
    }
    return result;
  }

  static saveDate(int year, int month, int day) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();

    if (year == now.year && month == now.month && day == now.day) {
      prefs.setBool('isSelectValid', false);
    } else {
      prefs.setBool('isSelectValid', true);
      prefs.setInt('selectYear', year);
      prefs.setInt('selectMonth', month);
      prefs.setInt('selectDay', day);
    }
  }

  static toInvalidDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isSelectValid', false);
  }
}
