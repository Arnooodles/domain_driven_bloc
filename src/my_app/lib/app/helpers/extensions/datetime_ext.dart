import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExt on DateTime {
  String defaultFormat() => DateFormat('MMM dd, yyyy').format(this);

  String get ago => timeago.format(DateTime.now().toUtc().subtract(DateTime.now().toUtc().difference(this)));
}
