import 'package:intl/intl.dart';

class DateFunctions {
  static String currentUtcTimeStamp() {
    return DateTime.now().toUtc().toIso8601String();
  }

  static String iso8601ToDisplay(String datetime) {
    DateTime now = DateTime.parse(datetime).toLocal();
    var formatter = DateFormat('yyyy-MM-dd').add_jm();
    // var formatter = DateFormat.yMMMMd('en_US').add_jm();
    var formatted = formatter.format(now);
    return formatted;
  }
}