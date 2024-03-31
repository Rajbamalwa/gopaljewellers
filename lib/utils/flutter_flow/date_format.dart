import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String dateTimeFormat(String format, DateTime? dateTime, {String? locale}) {
  if (dateTime == null) {
    return '';
  }
  if (format == 'relative') {
    return timeago.format(dateTime, locale: locale);
  }
  return DateFormat(format).format(dateTime);
}

changeStringToDate(dates) {
  for (String dateTimeString in dates) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    dates.add(dateTime);
  }
}
