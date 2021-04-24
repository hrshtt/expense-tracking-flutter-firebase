import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String timeAgoTime(DateTime date) {
  return timeago.format(date);
}

String formattedDate(DateTime date) {
  return DateFormat('dd MMM, yyyy').format(date);
}

String formattedTime(DateTime date) {
  return DateFormat('hh:mm a').format(date);
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}
