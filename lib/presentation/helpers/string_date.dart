import 'package:intl/intl.dart';

DateTime parseStringDate(String dateString) {
  DateFormat format = DateFormat('dd-MM-yyyy');
  DateTime parsedDate = format.parse(dateString);
  return parsedDate;
}

String parseDateTimeString(DateTime dateTime) {
  DateFormat format = DateFormat('dd-MM-yyyy');
  return format.format(dateTime);
}

