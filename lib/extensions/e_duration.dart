import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';

extension EDuration on Duration {
  String beautify(BuildContext context) {
    String twoDigits(int n) {
      if (n == 0) return '';
      if (n >= 10) return '$n';
      return '0$n';
    }

    List<String> parts = [];

    if (inDays != 0) {
      parts.add('$inDays ${L10n.of(context).e_duration_day}');
    }

    String twoDigitHours = twoDigits(inHours.remainder(24));
    if (twoDigitHours.isNotEmpty) {
      parts.add('$twoDigitHours ${L10n.of(context).e_duration_hour}');
    }

    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    if (twoDigitMinutes.isNotEmpty) {
      parts.add('$twoDigitMinutes ${L10n.of(context).e_duration_minute}');
    }

    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    if (twoDigitSeconds.isNotEmpty) {
      parts.add('$twoDigitSeconds ${L10n.of(context).e_duration_second}');
    }

    return parts.join(' ');
  }

  String toISO8601() {
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

    if (hoursOfDay > 0 || minutesOfHour > 0 || secondsOfMinute > 0) {
      isoString += 'T';
    }

    if (hoursOfDay > 0) {
      isoString += '${hoursOfDay}H';
    }

    if (minutesOfHour > 0) {
      isoString += '${minutesOfHour}M';
    }

    if (secondsOfMinute > 0) {
      isoString += '${secondsOfMinute}S';
    }

    return isoString;
  }
}
