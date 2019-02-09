import 'package:intl/intl.dart';

// This will format the date as needed
String dateFormatter() {
  var _now = DateTime.now();

  var _formatter = DateFormat(" EEE, MMM d, yyyy");
  String _formatted = _formatter.format(_now);

  return _formatted;
}
