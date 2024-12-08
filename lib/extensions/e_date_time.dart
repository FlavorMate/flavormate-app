import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension EDateTime on DateTime {
  String toLocalDateString(BuildContext context) {
    return DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
        .format(this);
  }

  String toLocalTimeString(BuildContext context) {
    return DateFormat.Hm(Localizations.localeOf(context).languageCode)
        .format(this);
  }

  String toLocalDateTimeString(BuildContext context) {
    return '${toLocalDateString(context)} - ${toLocalTimeString(context)}';
  }

  String toLocalDateTimeString2(BuildContext context) {
    return '${toLocalDateString(context)}\n${toLocalTimeString(context)}';
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
