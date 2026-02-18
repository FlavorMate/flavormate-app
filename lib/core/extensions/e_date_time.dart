import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension EDateTime on DateTime {
  DateTimeFormatterWrapper get formatter => DateTimeFormatterWrapper(this);

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class DateTimeFormatterWrapper {
  final DateTime _dateTime;

  const DateTimeFormatterWrapper(this._dateTime);

  DateTimeFormatter get dateTime => DateTimeFormatter(_dateTime);

  DateFormatter get date => DateFormatter(_dateTime);

  TimeFormatter get time => TimeFormatter(_dateTime);
}

class DateTimeFormatter {
  final DateTime _dateTime;

  const DateTimeFormatter(this._dateTime);

  String yyMMddHHmm(BuildContext context) {
    final date = _dateTime.formatter.date.yyyyMMdd(context);

    final time = _dateTime.formatter.time.jm(context);

    return '$date $time';
  }
}

class DateFormatter {
  final DateTime _dateTime;

  const DateFormatter(this._dateTime);

  String yyyyMMdd(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;

    final format = switch (language) {
      'en' => 'MM/dd/yyyy',
      'de' => 'dd.MM.yyyy',
      _ => '',
    };

    return DateFormat(format, language).format(_dateTime);
  }

  String yyyyMMMMdd(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;

    return DateFormat.yMMMMd(language).format(_dateTime);
  }
}

class TimeFormatter {
  final DateTime _dateTime;

  const TimeFormatter(this._dateTime);

  String jm(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;

    return DateFormat.jm(language).format(_dateTime);
  }
}
