import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

extension EDuration on Duration {
  String _twoDigits(int n) {
    if (n == 0) return '';
    if (n >= 10) return '$n';
    return '0$n';
  }

  String _filterDigits(int n) {
    if (n == 0) return '';
    return '$n';
  }

  String beautify(BuildContext context) {
    List<String> parts = [];

    if (inDays != 0) {
      parts.add('$inDays ${context.l10n.time__days_short}');
    }

    String twoDigitHours = _filterDigits(inHours.remainder(24));
    if (twoDigitHours.isNotEmpty) {
      parts.add('$twoDigitHours ${context.l10n.time__hours_short}');
    }

    String twoDigitMinutes = _twoDigits(inMinutes.remainder(60));
    if (twoDigitMinutes.isNotEmpty) {
      parts.add('$twoDigitMinutes ${context.l10n.time__minutes_short}');
    }

    String twoDigitSeconds = _twoDigits(inSeconds.remainder(60));
    if (twoDigitSeconds.isNotEmpty) {
      parts.add('$twoDigitSeconds ${context.l10n.time__seconds_short}');
    }

    return parts.join(' ');
  }

  String beautify2(BuildContext context) {
    final list = [];
    int days = inDays;
    int hours = inHours.remainder(24);
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);

    list.add('$days ${context.l10n.time__days_short}');
    list.add('$hours ${context.l10n.time__hours_short}');
    list.add('$minutes ${context.l10n.time__minutes_short}');
    list.add('$seconds ${context.l10n.time__seconds_short}');

    return list.join(' - ');
  }

  String get iso8601 {
    String isoString = 'P';

    if (isNegative) {
      throw Exception('Duration is negative!');
    }

    final int totalDays = inDays;
    final int totalHours = inHours;
    final int totalMinutes = inMinutes;
    final int totalSeconds = inSeconds;

    final int daysOfWeek = (totalDays >= 7) ? (totalDays / 7).floor() : 0;
    final int remainingDays = totalDays % 7;
    final int hoursOfDay = totalHours % 24;
    final int minutesOfHour = totalMinutes % 60;
    final int secondsOfMinute = totalSeconds % 60;

    if (daysOfWeek > 0) {
      isoString += '${daysOfWeek}W';
    }

    if (remainingDays > 0) {
      isoString += '${remainingDays}D';
    }

    isoString += 'T';

    isoString += '${hoursOfDay}H';

    isoString += '${minutesOfHour}M';

    isoString += '${secondsOfMinute}S';

    return isoString;
  }

  bool get isEmpty => inSeconds <= 0;
}
